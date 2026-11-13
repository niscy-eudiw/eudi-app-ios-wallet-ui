/*
 * Copyright (c) 2026 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import Foundation
import WalletStorage
import logic_business
import logic_storage

protocol DeferredIssuanceWorkManager: Sendable {
  /// Starts the loop. Entries that fell due while the app was closed are requested right away.
  func start() async
  /// Returns after any running check has finished, so nothing is written afterwards.
  func stop() async
  /// Re-reads the entries and reschedules. No-op while stopped.
  func wake() async
}

/// Requests deferred credentials as their entries fall due, one check at a time.
/// Sleeps until the next due entry; goes idle when nothing is pending until `wake()`.
final actor DeferredIssuanceWorkManagerImpl: DeferredIssuanceWorkManager {

  private let walletKitController: WalletKitController
  private let storageController: any DeferredIssuanceStorageController
  private let revocationWorkManager: RevocationWorkManager
  private let checkRunner: SerialCheckRunner
  private let now: @Sendable () -> Date
  private let sleep: @Sendable (TimeInterval) async throws -> Void

  private var isRunning = false
  /// nil while idle.
  private var loopTask: Task<Void, Never>?
  /// Bumped per loop, so a stale loop finishing after stop()/start() doesn't clear the new one.
  private var loopGeneration = 0
  /// Cancelled by wake() to run the next check immediately.
  private var waitTask: Task<Void, Error>?
  /// Set when wake() arrives mid-check, so the loop re-reads the entries instead of sleeping.
  private var isWakeRequested = false

  /// `now` and `sleep` are injectable so tests can control time.
  init(
    walletKitController: WalletKitController,
    storageController: any DeferredIssuanceStorageController,
    revocationWorkManager: RevocationWorkManager,
    checkRunner: SerialCheckRunner = SerialCheckRunner(),
    now: @escaping @Sendable () -> Date = { Date() },
    sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { try await Task.sleep(seconds: $0) }
  ) {
    self.walletKitController = walletKitController
    self.storageController = storageController
    self.revocationWorkManager = revocationWorkManager
    self.checkRunner = checkRunner
    self.now = now
    self.sleep = sleep
  }

  func start() async {
    guard !isRunning else { return }
    isRunning = true
    startLoopIfIdle()
  }

  func stop() async {
    isRunning = false
    loopTask?.cancel()
    loopTask = nil
    waitTask?.cancel()
    waitTask = nil
    await checkRunner.waitUntilIdle()
  }

  /// True when no loop is running (nothing pending, or stopped). Used by tests.
  var isIdle: Bool {
    loopTask == nil
  }

  func wake() async {
    guard isRunning else { return }
    guard loopTask != nil else {
      startLoopIfIdle()
      return
    }
    if let waitTask {
      waitTask.cancel()
    } else {
      isWakeRequested = true
    }
  }

  /// Syncs the entries with WalletKit's deferred documents, then requests the due ones, oldest first.
  /// Documents deferred before entries existed get one based on their last modification date.
  /// If the check is cancelled, no failure is recorded for the request in flight.
  func checkDeferredDocuments() async {

    guard let entries = try? await storageController.retrieveAllEntries() else { return }
    let documents = await walletKitController.fetchDeferredDocuments()
    guard let current = try? await reconcile(entries, with: documents) else { return }

    let date = now()
    let due = current
      .filter { $0.state == .pending && $0.nextAttemptAt <= date }
      .sorted { $0.nextAttemptAt < $1.nextAttemptAt }
    guard !due.isEmpty else { return }

    let revocationStatuses = (try? await walletKitController.fetchRevokedDocumentStatuses()) ?? [:]
    var issued: [String: String] = [:]
    var refused: [String: String] = [:]

    for entry in due {

      guard !Task.isCancelled else { break }
      guard let document = documents.first(where: { $0.id == entry.identifier }) else { continue }

      do {
        let result = try await walletKitController.requestDeferredIssuance(with: document)
        if !(result is DeferrredDocument) {
          issued[result.id] = result.displayName.orEmpty
        }
      } catch {
        guard !Task.isCancelled else { break }
        let failure = DeferredRequestFailure(error)
        try? await storageController.update(DeferredIssuanceSchedule.after(failure, of: entry, at: now()))
        if failure == .refused {
          refused[document.id] = document.displayName.orEmpty
        }
      }
    }

    if !issued.isEmpty {
      await checkRevocationAfterDeferredReIssue(asked: due.map(\.identifier), revocationStatuses: revocationStatuses)
    }

    if !issued.isEmpty || !refused.isEmpty {
      await notifyListeners(with: DeferredIssuancePayload(issued: issued, failed: refused))
      await notifyDocumentTabListener()
    }
  }

  /// Never less than `minimumInterval`, so an entry that couldn't be updated isn't retried in a tight loop.
  /// nil when nothing is pending; after a read error, tries again in `firstRetryDelay`.
  func delayUntilNextCheck() async -> TimeInterval? {
    let entries: [DeferredIssuance]
    do {
      entries = try await storageController.retrieveAllEntries()
    } catch {
      return DeferredIssuanceSchedule.firstRetryDelay
    }
    guard let next = entries.filter({ $0.state == .pending }).map(\.nextAttemptAt).min() else {
      return nil
    }
    return max(next.timeIntervalSince(now()), DeferredIssuanceSchedule.minimumInterval)
  }
}

private extension DeferredIssuanceWorkManagerImpl {

  func startLoopIfIdle() {
    guard loopTask == nil else { return }
    loopGeneration += 1
    let generation = loopGeneration
    loopTask = Task(priority: .utility) { [weak self] in
      await self?.runLoop(generation: generation)
    }
  }

  func runLoop(generation: Int) async {
    while isRunning, !Task.isCancelled {
      isWakeRequested = false
      await runCheck()
      guard isRunning, !Task.isCancelled else { break }
      let delay = await delayUntilNextCheck()
      if isWakeRequested { continue }
      guard let delay else { break }
      let wait = Task { [sleep] in try await sleep(delay) }
      waitTask = wait
      _ = try? await wait.value
      waitTask = nil
    }
    if generation == loopGeneration {
      loopTask = nil
    }
  }

  // Goes through checkRunner so stop() can wait for it.
  func runCheck() async {
    await checkRunner.run { [weak self] in
      guard let self, await self.isRunning else { return }
      await self.checkDeferredDocuments()
    }
  }

  /// Adds entries for deferred documents that have none and removes entries without a document.
  func reconcile(
    _ entries: [DeferredIssuance],
    with documents: [WalletStorage.Document]
  ) async throws -> [DeferredIssuance] {
    let deferredIds = Set(documents.map(\.id))
    let enteredIds = Set(entries.map(\.identifier))

    let missing = documents
      .filter { !enteredIds.contains($0.id) }
      .map {
        DeferredIssuanceSchedule.pending(
          identifier: $0.id,
          interval: $0.deferredIssuanceInterval,
          at: $0.modifiedAt ?? $0.createdAt
        )
      }
    let orphaned = entries.filter { !deferredIds.contains($0.identifier) }

    if !missing.isEmpty {
      try await storageController.store(missing)
    }
    for entry in orphaned {
      try await storageController.delete(entry.identifier)
    }
    return entries.filter { deferredIds.contains($0.identifier) } + missing
  }

  // WalletKit deletes the original of a deferred re-issue when the credential arrives. If that original had a
  // revocation record, run the revocation check now so the new copy's status is read right away (as on Android).
  func checkRevocationAfterDeferredReIssue(
    asked ids: [String],
    revocationStatuses: [String: DocumentRevocationStatus]
  ) async {
    let remainingIds = Set(await walletKitController.fetchAllDocuments().map(\.id))
    guard let goneId = ids.first(where: { revocationStatuses[$0] != nil && !remainingIds.contains($0) }) else {
      return
    }
    await revocationWorkManager.checkAfterReIssue(of: goneId)
  }

  @MainActor
  func notifyListeners(with payload: DeferredIssuancePayload) async {
    NotificationCenter.default.post(
      name: NSNotification.DeferredIssuanceResult,
      object: nil,
      userInfo: payload.userInfo
    )
  }

  @MainActor
  func notifyDocumentTabListener() async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}
