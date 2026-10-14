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

public protocol RevocationWorkManager: Sendable {
  func start() async
  func stop() async
}

final actor RevocationWorkManagerImpl: RevocationWorkManager {

  private let configLogic: WalletKitConfig
  private let walletKitController: WalletKitController

  private let initialDelay: TimeInterval = 30
  private var revocationTask: Task<Void, Never>?
  private var isRunning = false
  private var didRunInitialCheck = false

  init(configLogic: WalletKitConfig, walletKitController: WalletKitController) {
    self.configLogic = configLogic
    self.walletKitController = walletKitController
  }

  func start() async {

    guard revocationTask == nil else { return }

    isRunning = true

    revocationTask = Task(priority: .userInitiated) { [weak self] in

      guard let self else { return }

      try? await Task.sleep(seconds: self.firstCheckDelay())

      while await self.isRunning {
        try? await self.checkRevocation()
        try? await Task.sleep(seconds: self.configLogic.revocationIntervalSeconds)
      }
    }
  }

  func stop() async {
    isRunning = false
    revocationTask?.cancel()
    revocationTask = nil
  }

  /// The first check of the process comes `initialDelay` after the workers start, which is after login.
  /// Once it has run, a later start, after the workers were stopped, waits the full interval.
  func firstCheckDelay() -> TimeInterval {
    didRunInitialCheck ? configLogic.revocationIntervalSeconds : initialDelay
  }

  /// One sweep over the issued documents that carry a status list. A revocation is permanent; a
  /// suspension is cleared when the list reports the document valid again. A document whose status
  /// cannot be fetched keeps its record and the sweep goes on. A failed read of the stored records
  /// ends the sweep before anything is changed.
  func checkRevocation() async throws {

    didRunInitialCheck = true

    let issuedDocuments = await walletKitController.fetchIssuedDocuments()
    let storedStatuses = try await walletKitController.fetchRevokedDocumentStatuses()

    var newStatuses: [String: DocumentRevocationStatus] = [:]
    var revokedDocuments: [String: String] = [:]
    var suspendedDocuments: [String: String] = [:]
    var fromSuspendedToValid: [String] = []

    for document in issuedDocuments {

      guard let statusList = document.statusList else { continue }

      let status: CredentialStatus
      do {
        status = try await walletKitController.getDocumentStatus(for: statusList)
      } catch {
        continue
      }

      let storedStatus = storedStatuses[document.id]

      switch status {
      case .invalid:
        if storedStatus != .revoked {
          newStatuses[document.id] = .revoked
          revokedDocuments[document.displayName.orEmpty] = document.id
        }
      case .suspended:
        if storedStatus == nil {
          newStatuses[document.id] = .suspended
          suspendedDocuments[document.displayName.orEmpty] = document.id
        }
      case .valid:
        if storedStatus == .suspended {
          fromSuspendedToValid.append(document.id)
        }
      default:
        continue
      }
    }

    if !newStatuses.isEmpty {
      try await storeRevokedDocuments(with: newStatuses)
      await notifyListeners(revoked: revokedDocuments, suspended: suspendedDocuments)
    }

    if !fromSuspendedToValid.isEmpty {
      try await removeRevokedDocuments(with: fromSuspendedToValid)
      await notifyDocumentDetails(with: fromSuspendedToValid)
    }

    if !fromSuspendedToValid.isEmpty || !newStatuses.isEmpty {
      await notifyDocumentTabListener()
    }
  }

  private func storeRevokedDocuments(with statuses: [String: DocumentRevocationStatus]) async throws {
    try await walletKitController.storeRevokedDocuments(with: statuses)
  }

  private func removeRevokedDocuments(with ids: [String]) async throws {
    for id in ids {
      try await walletKitController.removeRevokedDocument(with: id)
    }
  }

  /// Tells the dashboard which documents were newly revoked and which newly suspended, and refreshes
  /// their details.
  @MainActor
  private func notifyListeners(revoked: [String: String], suspended: [String: String]) async {
    NotificationCenter.default.post(
      name: NSNotification.RevocationDashboard,
      object: nil,
      userInfo: RevocationDashboardPayload(revoked: revoked, suspended: suspended).userInfo
    )
    await notifyDocumentDetails(with: Array(revoked.values) + Array(suspended.values))
  }

  @MainActor
  private func notifyDocumentDetails(with ids: [String]) async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentDetailsRefresh,
      object: nil,
      userInfo: ["ids": ids]
    )
  }

  @MainActor
  private func notifyDocumentTabListener() async {
    NotificationCenter.default.post(
      name: NSNotification.DocumentTabRefresh,
      object: nil,
      userInfo: [:]
    )
  }
}

public extension NSNotification {
  static let RevocationDashboard = Notification.Name("RevocationDashboard")
}
