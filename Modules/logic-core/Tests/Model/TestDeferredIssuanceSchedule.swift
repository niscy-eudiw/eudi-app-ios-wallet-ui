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

  func testNextAttempt_WhenTheIssuerGaveAnInterval_ThenWaitsThatLong() {
    XCTAssertEqual(
      DeferredIssuanceSchedule.nextAttempt(after: now, interval: 42),
      now.addingTimeInterval(42)
    )
  }

  func testNextAttempt_WhenTheIntervalIsLong_ThenWaitsAllOfIt() {
    XCTAssertEqual(
      DeferredIssuanceSchedule.nextAttempt(after: now, interval: 86_400),
      now.addingTimeInterval(86_400)
    )
  }

  func testNextAttempt_WhenTheIntervalIsShorterThanTheMinimum_ThenWaitsTheMinimum() {
    for interval: TimeInterval in [0, 2, -10] {
      XCTAssertEqual(
        DeferredIssuanceSchedule.nextAttempt(after: now, interval: interval),
        now.addingTimeInterval(5),
        "\(interval)"
      )
    }
  }

  func testNextAttempt_WhenTheIssuerGaveNoInterval_ThenWaitsTheMinimum() {
    XCTAssertEqual(
      DeferredIssuanceSchedule.nextAttempt(after: now, interval: nil),
      now.addingTimeInterval(5)
    )
  }

  func testPending_ThenKeepsTheIntervalAsGivenWithNoFailures() {
    let entry = DeferredIssuanceSchedule.pending(identifier: "pid", interval: 2, at: now)

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

    let entries = DeferredIssuanceSchedule.entries(for: documents, at: now)

    XCTAssertEqual(entries.map(\.identifier), ["pid", "age"])
    XCTAssertTrue(entries.allSatisfy { $0.state == .pending && $0.failedAttempts == 0 })
  }

  func testEntries_WhenNoDocumentIsDeferred_ThenSchedulesNothing() {
    let entries = DeferredIssuanceSchedule.entries(for: [document(id: "pid", status: .issued)], at: now)

    XCTAssertTrue(entries.isEmpty)
  }

  func testEntries_WhenTheDeferredDocumentHoldsNoInterval_ThenAsksAgainAfterTheMinimum() {
    let entries = DeferredIssuanceSchedule.entries(for: [document(id: "pid", status: .deferred)], at: now)

    XCTAssertEqual(entries.first?.interval, nil)
    XCTAssertEqual(entries.first?.nextAttemptAt, now.addingTimeInterval(5))
  }

  func testRetryDelay_ThenDoublesFromThirtySecondsUpToAnHour() {
    let delays = (1...9).map { DeferredIssuanceSchedule.retryDelay(afterFailures: $0) }

    XCTAssertEqual(delays, [30, 60, 120, 240, 480, 960, 1920, 3600, 3600])
    XCTAssertEqual(DeferredIssuanceSchedule.retryDelay(afterFailures: 1_000), 3600)
  }

  func testAfter_WhenTheFirstRequestFailsTransiently_ThenWaitsThirtySecondsAndCountsTheFailure() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 5)

    let next = DeferredIssuanceSchedule.after(.transient, of: entry, at: now)

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

    let next = DeferredIssuanceSchedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.failedAttempts, 3)
    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(120))
  }

  func testAfter_WhenTheIssuersIntervalIsLongerThanTheRetryDelay_ThenWaitsTheInterval() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 7_200)

    let next = DeferredIssuanceSchedule.after(.transient, of: entry, at: now)

    XCTAssertEqual(next.nextAttemptAt, now.addingTimeInterval(7_200))
  }

  func testAfter_WhenTheIssuerRefuses_ThenStopsAskingAndKeepsTheRest() {
    let entry = DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, failedAttempts: 2)

    let next = DeferredIssuanceSchedule.after(.refused, of: entry, at: now.addingTimeInterval(100))

    XCTAssertEqual(
      next,
      DeferredIssuance(identifier: "pid", nextAttemptAt: now, interval: 60, failedAttempts: 2, state: .failed)
    )
  }
}

private extension TestDeferredIssuanceSchedule {

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
