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

  func testScheduleRevocationCheck_WhenCalled_ThenTheCheckRunsWithoutBeingAwaited() async {
    let checked = expectation(description: "revocation check")
    stub(revocationWorkManager) { mock in
      when(mock.checkAfterReIssue(of: equal(to: "original"))).then { _ in checked.fulfill() }
    }

    await scheduler.scheduleRevocationCheck(afterReIssueOf: "original")

    await fulfillment(of: [checked], timeout: 5)
  }
}
