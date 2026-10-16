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
import logic_business
import logic_core

/// Why a factory reset stopped. Every step can run again, so the user can retry.
enum WalletResetError: Error {
  /// A background check was still running when `WalletKitConfig.workerStopTimeoutSeconds` ran out; nothing was
  /// deleted.
  case backgroundWorkStillRunning
  /// Documents were still stored after the deletion passes.
  case documentsRemain
  /// The keychain could not be cleared.
  case keychainNotCleared
}

/// The factory reset, as the Android wallet's `WalletCoreResetController`. It deletes every document and its keys,
/// the transaction history and the app's other records, the PIN, the biometric and other settings, and the cached
/// files, while the app keeps running, so that the wallet starts again at onboarding.
public protocol WalletResetController: Sendable {
  /// Runs the reset. The background checks are stopped first, and the reset fails without deleting anything when
  /// one is still running after `WalletKitConfig.workerStopTimeoutSeconds`. The documents are deleted through
  /// WalletKit, which also logs their deletion and updates the Digital Credential API registrations; the history is
  /// cleared after that, then the other records, the keychain, the preferences except the language, and the
  /// cached and temporary files; the session is locked last. Once started, the reset runs to the end even if its
  /// caller is cancelled, and `WalletResetStatusProvider.isResetting` is true meanwhile. A failed step throws and
  /// restarts the background checks; running the reset again is safe.
  func resetWallet() async throws
}

final actor WalletResetControllerImpl: WalletResetController {

  private let walletKitController: WalletKitController
  private let walletWorkScheduler: WalletWorkScheduler
  private let keyChainController: KeyChainController
  private let prefsController: PrefsController
  private let sessionController: SessionController
  private let resetStatusProvider: WalletResetStatusProvider
  private let removeCachedFiles: @Sendable () throws -> Void
  private var runningReset: Task<Void, Error>?

  init(
    walletKitController: WalletKitController,
    walletWorkScheduler: WalletWorkScheduler,
    keyChainController: KeyChainController,
    prefsController: PrefsController,
    sessionController: SessionController,
    resetStatusProvider: WalletResetStatusProvider,
    removeCachedFiles: @escaping @Sendable () throws -> Void = WalletResetControllerImpl.removeCachedAndTemporaryFiles
  ) {
    self.walletKitController = walletKitController
    self.walletWorkScheduler = walletWorkScheduler
    self.keyChainController = keyChainController
    self.prefsController = prefsController
    self.sessionController = sessionController
    self.resetStatusProvider = resetStatusProvider
    self.removeCachedFiles = removeCachedFiles
  }

  func resetWallet() async throws {
    if let runningReset {
      return try await runningReset.value
    }
    let reset = Task { try await self.performReset() }
    runningReset = reset
    defer { runningReset = nil }
    try await reset.value
  }

  /// The app's caches, WalletKit's log file and the image cache among them, and its temporary files.
  static func removeCachedAndTemporaryFiles() throws {
    let fileManager = FileManager.default
    let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask) + [fileManager.temporaryDirectory]
    for directory in directories {
      for item in (try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? [] {
        try fileManager.removeItem(at: item)
      }
    }
  }
}

private extension WalletResetControllerImpl {

  enum Constants {
    static let deletionPasses = 2
  }

  func performReset() async throws {
    resetStatusProvider.setResetting(true)
    defer { resetStatusProvider.setResetting(false) }

    guard await walletWorkScheduler.stop() else {
      await walletWorkScheduler.schedule()
      throw WalletResetError.backgroundWorkStillRunning
    }

    do {
      try await deleteDocuments()
      try await walletKitController.deleteAllRecords()
      guard keyChainController.clear() else { throw WalletResetError.keychainNotCleared }
      clearPreferences()
      try removeCachedFiles()
      await sessionController.lock()
    } catch {
      await walletWorkScheduler.schedule()
      throw error
    }
  }

  /// Deletes every document WalletKit stores, in up to `Constants.deletionPasses` passes, so that one stored by
  /// a check that was still finishing goes too. Whether any is left is read from the keychain itself.
  func deleteDocuments() async throws {
    for _ in 0..<Constants.deletionPasses {
      try await walletKitController.clearAllDocuments()
      if try await !walletKitController.hasStoredDocuments() { return }
    }
    throw WalletResetError.documentsRemain
  }

  /// Every preference goes except the language, so that onboarding runs again.
  func clearPreferences() {
    for key in Prefs.Key.allCases where key != .language {
      prefsController.remove(forKey: key)
    }
  }
}
