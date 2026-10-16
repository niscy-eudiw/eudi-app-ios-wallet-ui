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
import Cuckoo
@testable import logic_core
@testable import logic_test

final class TestWalletWorkScheduler: EudiTest {

  var revocationWorkManager: MockRevocationWorkManager!
  var reIssuanceWorkManager: MockReIssuanceWorkManager!
  var scheduler: WalletWorkSchedulerImpl!

  override func setUp() {
    revocationWorkManager = MockRevocationWorkManager()
    reIssuanceWorkManager = MockReIssuanceWorkManager()
    stub(revocationWorkManager) { mock in
      when(mock.start()).thenDoNothing()
      when(mock.stop()).thenDoNothing()
    }
    stub(reIssuanceWorkManager) { mock in
      when(mock.start()).thenDoNothing()
      when(mock.stop()).thenDoNothing()
    }
    scheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      stopTimeout: 5
    )
  }

  override func tearDown() {
    revocationWorkManager = nil
    reIssuanceWorkManager = nil
    scheduler = nil
  }

  func testSchedule_WhenCalled_ThenStartsBothChecks() async {
    await scheduler.schedule()

    verify(revocationWorkManager).start()
    verify(reIssuanceWorkManager).start()
  }

  func testStop_WhenCalled_ThenStopsBothChecks() async {
    let stopped = await scheduler.stop()

    XCTAssertTrue(stopped)
    verify(revocationWorkManager).stop()
    verify(reIssuanceWorkManager).stop()
  }

  func testStop_WhenACheckOutlastsTheTimeout_ThenReportsItStillRunning() async {
    let gate = AsyncGate()
    let blockedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: SlowStoppingReIssuanceWorkManager(gate: gate),
      stopTimeout: 0.2
    )

    let stopped = await blockedScheduler.stop()
    await gate.open()

    XCTAssertFalse(stopped)
  }

  func testScheduleRevocationCheck_WhenTheCheckIsStillRunning_ThenReturnsAndTheCheckFinishesLater() async {
    let gate = AsyncGate()
    let finished = expectation(description: "revocation check finished")
    let revocationWorkManager = RecordingRevocationWorkManager(gate: gate, finished: finished)
    let gatedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager,
      stopTimeout: 5
    )
    let returned = expectation(description: "scheduling returned")

    Task {
      await gatedScheduler.scheduleRevocationCheck(afterReIssueOf: "original")
      returned.fulfill()
    }
    await fulfillment(of: [returned], timeout: 2)
    await gate.open()

    await fulfillment(of: [finished], timeout: 5)
    let checkedIds = await revocationWorkManager.checkedIds
    XCTAssertEqual(checkedIds, ["original"])
  }
}

private actor RecordingRevocationWorkManager: RevocationWorkManager {
  private let gate: AsyncGate
  private let finished: XCTestExpectation
  private(set) var checkedIds: [String] = []

  init(gate: AsyncGate, finished: XCTestExpectation) {
    self.gate = gate
    self.finished = finished
  }

  func start() async {}

  func stop() async {}

  func checkAfterReIssue(of originalId: String) async {
    checkedIds.append(originalId)
    await gate.wait()
    finished.fulfill()
  }
}

private actor SlowStoppingReIssuanceWorkManager: ReIssuanceWorkManager {
  private let gate: AsyncGate

  init(gate: AsyncGate) {
    self.gate = gate
  }

  func start() async {}

  func stop() async {
    await gate.wait()
  }
}
