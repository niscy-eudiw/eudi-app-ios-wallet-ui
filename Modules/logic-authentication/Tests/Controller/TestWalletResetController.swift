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
import XCTest
import os
import Cuckoo
import logic_business
@testable import logic_core
@testable import logic_authentication
@testable import logic_test

final class TestWalletResetController: EudiTest {

  private var walletKitController: MockWalletKitController!
  private var walletWorkScheduler: MockWalletWorkScheduler!
  private var keyChainController: MockKeyChainController!
  private var prefsController: MockPrefsController!
  private var sessionController: MockSessionController!
  private var resetStatusProvider: WalletResetStatusProviderImpl!
  private var calls: StepLog!
  private var controller: WalletResetControllerImpl!

  override func setUp() {
    super.setUp()
    walletKitController = MockWalletKitController()
    walletWorkScheduler = MockWalletWorkScheduler()
    keyChainController = MockKeyChainController()
    prefsController = MockPrefsController()
    sessionController = MockSessionController()
    resetStatusProvider = WalletResetStatusProviderImpl()
    calls = StepLog()
    stubEverySucceeding()
    controller = makeController()
  }

  override func tearDown() {
    controller = nil
    calls = nil
    resetStatusProvider = nil
    sessionController = nil
    prefsController = nil
    keyChainController = nil
    walletWorkScheduler = nil
    walletKitController = nil
    super.tearDown()
  }

  func testResetWallet_WhenEveryStepSucceeds_ThenRunsThemInOrderAndLocksTheSession() async throws {
    try await controller.resetWallet()

    XCTAssertEqual(
      calls.entries,
      ["stop", "documents", "records", "keychain", "preferences", "files", "lock"]
    )
    verify(walletWorkScheduler, never()).schedule()
    XCTAssertFalse(resetStatusProvider.isResetting)
  }

  func testResetWallet_WhenACheckIsStillRunning_ThenDeletesNothingAndRestartsTheChecks() async {
    stub(walletWorkScheduler) { mock in
      when(mock.stop()).thenReturn(false)
    }

    await assertResetFails()

    verify(walletKitController, never()).clearAllDocuments()
    verify(keyChainController, never()).clear()
    verify(walletWorkScheduler).schedule()
  }

  func testResetWallet_WhenAStepFails_ThenStopsThereAndRestartsTheChecks() async {
    stub(walletKitController) { mock in
      when(mock.deleteAllRecords()).thenThrow(WalletCoreError.unableToIssueAndStore)
    }

    await assertResetFails()

    verify(keyChainController, never()).clear()
    verify(walletWorkScheduler).schedule()
    XCTAssertFalse(resetStatusProvider.isResetting)
  }

  func testResetWallet_WhenDocumentsRemainAfterEveryPass_ThenFailsBeforeTheRecords() async {
    stub(walletKitController) { mock in
      when(mock.hasStoredDocuments()).thenReturn(true)
    }

    await assertResetFails()

    verify(walletKitController, times(2)).clearAllDocuments()
    verify(walletKitController, never()).deleteAllRecords()
  }

  func testResetWallet_WhenItRuns_ThenReportsItIsResettingAndKeepsTheLanguage() async throws {
    let wasResetting = OSAllocatedUnfairLock(initialState: false)
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).then { [resetStatusProvider] in
        wasResetting.withLock { $0 = resetStatusProvider?.isResetting ?? false }
      }
    }

    try await controller.resetWallet()

    XCTAssertTrue(wasResetting.withLock { $0 })
    verify(prefsController, never()).remove(forKey: equal(to: .language))
    verify(prefsController).remove(forKey: equal(to: .runAtLeastOnce))
  }
}

private extension TestWalletResetController {

  func assertResetFails(file: StaticString = #filePath, line: UInt = #line) async {
    do {
      try await controller.resetWallet()
      XCTFail("Expected the reset to fail", file: file, line: line)
    } catch {}
  }

  func makeController() -> WalletResetControllerImpl {
    WalletResetControllerImpl(
      walletKitController: walletKitController,
      walletWorkScheduler: walletWorkScheduler,
      keyChainController: keyChainController,
      prefsController: prefsController,
      sessionController: sessionController,
      resetStatusProvider: resetStatusProvider,
      removeCachedFiles: { [calls] in calls?.record("files") }
    )
  }

  func stubEverySucceeding() {
    let calls = self.calls!
    stub(walletWorkScheduler) { mock in
      when(mock.stop()).then { calls.record("stop"); return true }
      when(mock.schedule()).thenDoNothing()
    }
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).then { calls.record("documents") }
      when(mock.hasStoredDocuments()).thenReturn(false)
      when(mock.deleteAllRecords()).then { calls.record("records") }
    }
    stub(keyChainController) { mock in
      when(mock.clear()).then { calls.record("keychain"); return true }
    }
    stub(prefsController) { mock in
      when(mock.remove(forKey: any())).then { key in
        if key == .runAtLeastOnce { calls.record("preferences") }
      }
    }
    stub(sessionController) { mock in
      when(mock.lock()).then { calls.record("lock") }
    }
  }
}

private final class StepLog: Sendable {
  private let log = OSAllocatedUnfairLock<[String]>(initialState: [])

  var entries: [String] { log.withLock { $0 } }

  func record(_ entry: String) {
    log.withLock { $0.append(entry) }
  }
}
