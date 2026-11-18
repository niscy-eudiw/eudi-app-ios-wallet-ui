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
import WalletStorage
import logic_storage
@testable import logic_core
@testable import logic_test

final class TestDeferredIssuanceSchedule: EudiTest {

  private let now = Date(timeIntervalSince1970: 1_000)
  private let schedule = DeferredIssuanceSchedule(config: .stub)

  func testNextAttempt_WhenTheIssuerGaveAnInterval_ThenWaitsThatLong() {
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: 42),
      now.addingTimeInterval(42)
    )
  }

  func testNextAttempt_WhenTheIntervalIsLong_ThenWaitsAllOfIt() {
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: 86_400),
      now.addingTimeInterval(86_400)
    )
  }

  func testNextAttempt_WhenTheIntervalIsShorterThanTheMinimum_ThenWaitsTheMinimum() {
    for interval: TimeInterval in [0, 2, -10] {
      XCTAssertEqual(
        schedule.nextAttempt(after: now, interval: interval),
        now.addingTimeInterval(5),
        "\(interval)"
      )
    }
  }

  func testNextAttempt_WhenTheIssuerGaveNoInterval_ThenWaitsTheMinimum() {
    XCTAssertEqual(
      schedule.nextAttempt(after: now, interval: nil),
      now.addingTimeInterval(5)
    )
  }

  func testNextAttempt_WhenTheIssuerGaveNoInterval_ThenWaitsTheConfiguredInitialDelay() {
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelay: 30))

    XCTAssertEqual(schedule.nextAttempt(after: now, interval: nil), now.addingTimeInterval(30))
    XCTAssertEqual(schedule.nextAttempt(after: now, interval: 10), now.addingTimeInterval(10))
  }

  func testNextAttempt_WhenTheConfiguredInitialDelayIsShorterThanTheMinimum_ThenWaitsTheMinimum() {
    let schedule = DeferredIssuanceSchedule(config: config(initialPollingDelay: 1))

    XCTAssertEqual(schedule.nextAttempt(after: now, interval: nil), now.addingTimeInterval(5))
  }

  func testPending_ThenKeepsTheIntervalAsGivenWithNoFailures() {
    let entry = schedule.pending(identifier: "pid", interval: 2, at: now)

    XCTAssertEqual(
      entry,
      DeferredIssuance(
        identifier: "pid",
        nextAttemptAt: now.addingTimeInterval(5),
        interval: 2,
        failedAttempts: 0,
        state: .pending
      )
    )
  }

  func testEntries_WhenSomeDocumentsAreDeferred_ThenSchedulesOnlyThose() {
    let documents = [
      document(id: "pid", status: .deferred),
      document(id: "mdl", status: .issued),
      document(id: "age", status: .deferred),
      document(id: "pending", status: .pending)
    ]

    let entries = schedule.entries(for: documents, at: now)

    XCTAssertEqual(entries.map(\.identifier), ["pid", "age"])
    XCTAssertTrue(entries.allSatisfy { $0.state == .pending && $0.failedAttempts == 0 })
  }

  func testEntries_WhenNoDocumentIsDeferred_ThenSchedulesNothing() {
    let entries = schedule.entries(for: [document(id: "pid", status: .issued)], at: now)

    XCTAssertTrue(entries.isEmpty)
  }

  func testEntries_WhenTheDeferredDocumentHoldsNoInterval_ThenAsksAgainAfterTheMinimum() {
    let entries = schedule.entries(for: [document(id: "pid", status: .deferred)], at: now)

    XCTAssertEqual(entries.first?.interval, nil)
    XCTAssertEqual(entries.first?.nextAttemptAt, now.addingTimeInterval(5))
  }

  func testRetryDelay_ThenDoublesFromThirtySecondsUpToAnHour() {
    let delays = (1...9).map { schedule.retryDelay(afterFailures: $0) }

    XCTAssertEqual(delays, [30, 60, 120, 240, 480, 960, 1920, 3600, 3600])
    XCTAssertEqual(schedule.retryDelay(afterFailures: 1_000), 3600)
  }

  func testRetryDelay_WhenTheRetryDelaysAreConfigured_ThenDoublesFromTheFirstUpToTheLongest() {
    let schedule = DeferredIssuanceSchedule(config: config(failureRetryDelay: 10, maximumFailureRetryDelay: 50))

    let delays = (1...5).map { schedule.retryDelay(afterFailures: $0) }

    XCTAssertEqual(delays, [10, 20, 40, 50, 50])
  }

  func testAfter_WhenTheRetryDelayIsConfigured_ThenTheFirstFailureWaitsThatLong() {
    let schedule = DeferredIssuanceSchedule(config: config(failureRetryDelay: 45, maximumFailureRetryDelay: 90))
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 5)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(45))
  }

  func testAfter_WhenTheFirstRequestFailsTransiently_ThenWaitsThirtySecondsAndCountsTheFailure() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 5)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(
      next,
      DeferredIssuance(
        identifier: "pid",
        nextAttemptAt: now.addingTimeInterval(30),
        interval: 5,
        failedAttempts: 1,
        state: .pending
      )
    )
  }

  func testAfter_WhenRequestsKeepFailingTransiently_ThenWaitsLongerEachTime() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, failedAttempts: 2)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.failedAttempts, 3)
    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(120))
  }

  func testAfter_WhenTheIssuersIntervalIsLongerThanTheRetryDelay_ThenWaitsTheInterval() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 7_200)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(7_200))
  }

  func testAfter_WhenTheFailuresInARowReachTheLimit_ThenStopsAsking() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, failedAttempts: 4)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.failedAttempts, 5)
    XCTAssertEqual(next.state, .failed)
  }

  func testAfter_WhenTheFailuresInARowStayUnderTheLimit_ThenKeepsAsking() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, failedAttempts: 3)

    let next = schedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.failedAttempts, 4)
    XCTAssertEqual(next.state, .pending)
  }

  func testAfter_WhenTheLimitIsConfigured_ThenStopsAskingThere() {
    let schedule = DeferredIssuanceSchedule(config: config(maxConsecutiveFailedAttempts: 2))

    let first = schedule.after(.transient, of: DeferredIssuance(identifier: "pid", nextAttemptAt: now), at: now)
    let second = schedule.after(.transient, of: first, at: now)

    XCTAssertEqual(first.state, .pending)
    XCTAssertEqual(second.state, .failed)
  }

  func testAfter_WhenTheDeviceIsOffline_ThenWaitsAsAfterAFailureWithoutCountingIt() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 5, failedAttempts: 4)

    let next = schedule.after(.offline, of: entry, at: now)

    XCTAssertEqual(
      next,
      DeferredIssuance(
        identifier: "pid",
        nextAttemptAt: now.addingTimeInterval(480),
        interval: 5,
        failedAttempts: 4,
        state: .pending
      )
    )
  }

  func testAfter_WhenTheIssuerRefuses_ThenStopsAskingAndKeepsTheRest() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, failedAttempts: 2)

    let next = schedule.after(.refused, of: entry, at: now.addingTimeInterval(100))

    XCTAssertEqual(
      next,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, failedAttempts: 2, state: .failed)
    )
  }
}

private extension TestDeferredIssuanceSchedule {

  func config(
    initialPollingDelay: TimeInterval = 5,
    failureRetryDelay: TimeInterval = 30,
    maximumFailureRetryDelay: TimeInterval = 3600,
    maxConsecutiveFailedAttempts: Int = 5
  ) -> DeferredIssuanceConfig {
    DeferredIssuanceConfig(
      initialPollingDelay: initialPollingDelay,
      failureRetryDelay: failureRetryDelay,
      maximumFailureRetryDelay: maximumFailureRetryDelay,
      maxConsecutiveFailedAttempts: maxConsecutiveFailedAttempts
    )
  }

  func document(id: String, status: WalletStorage.DocumentStatus) -> WalletStorage.Document {
    WalletStorage.Document(
      id: id,
      docType: "",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: "",
      status: status
    )
  }
}
