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
      reIssuanceWorkManager: reIssuanceWorkManager
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
    await scheduler.stop()

    verify(revocationWorkManager).stop()
    verify(reIssuanceWorkManager).stop()
  }

  func testScheduleRevocationCheck_WhenTheCheckIsStillRunning_ThenReturnsAndTheCheckFinishesLater() async {
    let gate = AsyncGate()
    let finished = expectation(description: "revocation check finished")
    let revocationWorkManager = RecordingRevocationWorkManager(gate: gate, finished: finished)
    let gatedScheduler = WalletWorkSchedulerImpl(
      revocationWorkManager: revocationWorkManager,
      reIssuanceWorkManager: reIssuanceWorkManager
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
