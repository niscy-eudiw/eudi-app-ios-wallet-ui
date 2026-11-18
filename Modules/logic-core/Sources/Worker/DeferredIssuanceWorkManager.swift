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
import UIKit
import WalletStorage
import logic_business
import logic_storage

extension Notification.Name {
  /// Posted by WalletKitController after adding an entry, so an idle deferred work manager picks it up.
  static let deferredIssuanceEntered = Notification.Name("DeferredIssuanceEntered")
}

protocol DeferredIssuanceWorkManager: Sendable {
  /// Starts the loop. Entries that fell due while the app was closed are requested right away.
  func start() async
  /// Returns after any running check has finished, so nothing is written afterwards.
  func stop() async
  /// Re-reads the entries and reschedules. No-op while stopped.
  func wake() async
}

/// Requests deferred credentials as their entries fall due, one check at a time.
/// Sleeps until the next due entry, at most `maximumWait` at a time; goes idle when nothing is pending until `wake()`.
/// Also woken by `wakingNotifications` while running.
final actor DeferredIssuanceWorkManagerImpl: DeferredIssuanceWorkManager {

  // Task.sleep doesn't advance while the device sleeps, so re-check on returning to the foreground.
  static let wakingNotifications: [Notification.Name] = [
    .deferredIssuanceEntered,
    UIApplication.willEnterForegroundNotification
  ]

  // A longer wait is split into pieces: the issuer's interval has no upper limit and Task.sleep traps
  // past UInt64 nanoseconds. Each wake-up only reads the entries; nothing is requested before it's due.
  static let maximumWait: TimeInterval = 60 * 60

  private let walletKitController: WalletKitController
  private let storageController: any DeferredIssuanceStorageController
  private let revocationWorkManager: RevocationWorkManager
  private let schedule: DeferredIssuanceSchedule
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
  /// Registered in start(), removed in stop().
  private var wakingObservers: [any NSObjectProtocol] = []

  /// `now` and `sleep` are injectable so tests can control time.
  init(
    walletKitController: WalletKitController,
    storageController: any DeferredIssuanceStorageController,
    revocationWorkManager: RevocationWorkManager,
    schedule: DeferredIssuanceSchedule,
    checkRunner: SerialCheckRunner = SerialCheckRunner(),
    now: @escaping @Sendable () -> Date = { Date() },
    sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { try await Task.sleep(seconds: $0) }
  ) {
    self.walletKitController = walletKitController
    self.storageController = storageController
    self.revocationWorkManager = revocationWorkManager
    self.schedule = schedule
    self.checkRunner = checkRunner
    self.now = now
    self.sleep = sleep
  }

  func start() async {
    guard !isRunning else { return }
    isRunning = true
    wakingObservers = Self.wakingNotifications.map { name in
      NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { [weak self] _ in
        Task { await self?.wake() }
      }
    }
    startLoopIfIdle()
  }

  func stop() async {
    isRunning = false
    wakingObservers.forEach { NotificationCenter.default.removeObserver($0) }
    wakingObservers = []
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

    var issued: [String: String] = [:]
    var failed: [String: String] = [:]

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
        let next = schedule.after(DeferredRequestFailure(error), of: entry, at: now())
        try? await storageController.update(next)
        if next.state == .failed {
          failed[document.id] = document.displayName.orEmpty
        }
      }
    }

    if !issued.isEmpty {
      await checkRevocationAfterDeferredReIssue()
    }

    if !issued.isEmpty || !failed.isEmpty {
      await notifyListeners(with: DeferredIssuancePayload(issued: issued, failed: failed))
      await notifyDocumentTabListener()
    }
  }

  /// Never less than `minimumInterval`, so an entry that couldn't be updated isn't retried in a tight loop,
  /// and never more than `maximumWait`. nil when nothing is pending; after a read error, tries again in
  /// `failureRetryDelay`.
  func delayUntilNextCheck() async -> TimeInterval? {
    let entries: [DeferredIssuance]
    do {
      entries = try await storageController.retrieveAllEntries()
    } catch {
      return schedule.config.failureRetryDelay
    }
    guard let next = entries.filter({ $0.state == .pending }).map(\.nextAttemptAt).min() else {
      return nil
    }
    let delay = max(next.timeIntervalSince(now()), DeferredIssuanceSchedule.minimumInterval)
    return min(delay, Self.maximumWait)
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
      // stop() may have come during the read; a wait started now would outlive it.
      guard isRunning, !Task.isCancelled else { break }
      if isWakeRequested { continue }
      guard let delay else { break }
      let wait = Task { [sleep] in try await sleep(delay) }
      waitTask = wait
      _ = try? await wait.value
      // After stop() and start() this may already be the next loop's wait.
      if waitTask == wait {
        waitTask = nil
      }
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
        schedule.pending(
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

  // When a re-issue comes back deferred, WalletKit deletes the original right away but the wallet keeps its
  // revocation record. Once the credential arrives, such a leftover record means the new copy's status should
  // be read now instead of on the next revocation check (as on Android).
  func checkRevocationAfterDeferredReIssue() async {
    guard let revocationStatuses = try? await walletKitController.fetchRevokedDocumentStatuses() else { return }
    let remainingIds = Set(await walletKitController.fetchAllDocuments().map(\.id))
    guard let goneId = revocationStatuses.keys.first(where: { !remainingIds.contains($0) }) else { return }
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
