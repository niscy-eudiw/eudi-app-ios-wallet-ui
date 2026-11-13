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
import WalletStorage
import logic_storage
import enum OpenID4VCI.CredentialIssuanceError
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestDeferredIssuanceWorkManager: EudiTest {

  private let startDate = Date(timeIntervalSince1970: 100_000)

  private var walletKitController: MockWalletKitController!
  private var revocationWorkManager: MockRevocationWorkManager!
  private var storage: StubDeferredIssuanceStorageController!
  private var clock: TestClock!
  private var workManager: DeferredIssuanceWorkManagerImpl!

  override func setUp() {
    super.setUp()
    walletKitController = MockWalletKitController()
    revocationWorkManager = MockRevocationWorkManager()
    storage = StubDeferredIssuanceStorageController()
    clock = TestClock(startDate)
    workManager = makeManager()
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn([])
      when(mock.fetchRevokedDocumentStatuses()).thenReturn([:])
      when(mock.fetchAllDocuments()).thenReturn([])
    }
    stub(revocationWorkManager) { mock in
      when(mock.checkAfterReIssue(of: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    workManager = nil
    clock = nil
    storage = nil
    revocationWorkManager = nil
    walletKitController = nil
    super.tearDown()
  }

  // MARK: - A check

  func testCheck_WhenAnEntryIsDue_ThenAsksItsIssuerOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    verify(walletKitController, times(1)).requestDeferredIssuance(with: document("a"))
  }

  func testCheck_WhenAnEntryIsNotDueYet_ThenDoesNotAsk() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60)])

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenAnEntryFailed_ThenDoesNotAskAgain() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, state: .failed)])

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheIssuerIsNotReady_ThenLeavesTheEntryToTheController() async {
    let due = entry("a", dueIn: -10, interval: 60)
    await givenDeferred(["a"], entries: [due])
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored, due)
  }

  func testCheck_WhenTheRequestFailsTransiently_ThenCountsTheFailureAndWaitsLonger() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10, interval: 5)])
    stubRequest { _ in throw URLError(.timedOut) }

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(
      stored,
      DeferredIssuance(
        identifier: "a",
        nextAttemptAt: startDate.addingTimeInterval(30),
        interval: 5,
        failedAttempts: 1,
        state: .pending
      )
    )
  }

  func testCheck_WhenTheIssuerRefuses_ThenMarksTheEntryFailedAndAnnouncesIt() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in throw CredentialIssuanceError.invalidTransactionId }
    let announced = expectation(forNotification: NSNotification.DeferredIssuanceResult, object: nil) { notification in
      DeferredIssuancePayload(userInfo: notification.userInfo)
        == DeferredIssuancePayload(issued: [:], failed: ["a": "Document a"])
    }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    let stored = await storage.entries["a"]
    XCTAssertEqual(stored?.state, .failed)
    await fulfillment(of: [announced, refreshed], timeout: 2)
  }

  func testCheck_WhenTheCredentialIsIssued_ThenAnnouncesTheIssuedDocument() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { _ in StubDocument.make(id: "issued-a", displayName: "PID") }
    let announced = expectation(forNotification: NSNotification.DeferredIssuanceResult, object: nil) { notification in
      DeferredIssuancePayload(userInfo: notification.userInfo)
        == DeferredIssuancePayload(issued: ["issued-a": "PID"], failed: [:])
    }
    let refreshed = expectation(forNotification: NSNotification.DocumentTabRefresh, object: nil)

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [announced, refreshed], timeout: 2)
  }

  func testCheck_WhenNothingIsSettled_ThenAnnouncesNothing() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stubRequest { document in deferredDocument(document.id) }
    let announced = expectation(forNotification: NSNotification.DeferredIssuanceResult, object: nil)
    announced.isInverted = true

    await workManager.checkDeferredDocuments()

    await fulfillment(of: [announced], timeout: 0.5)
  }

  func testCheck_WhenSeveralAreDue_ThenAsksTheLongestDueFirst() async {
    await givenDeferred(
      ["a", "b", "c"],
      entries: [entry("a", dueIn: -10), entry("b", dueIn: -300), entry("c", dueIn: -60)]
    )
    let asked = OSAllocatedUnfairLock<[String]>(initialState: [])
    stubRequest { document in
      asked.withLock { $0.append(document.id) }
      return deferredDocument(document.id)
    }

    await workManager.checkDeferredDocuments()

    XCTAssertEqual(asked.withLock { $0 }, ["b", "c", "a"])
  }

  func testCheck_WhenADeferredDocumentHasNoEntry_ThenGivesItOneFromWhenItWasDeferred() async {
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn([
        storedDocument("old", modifiedAt: startDate.addingTimeInterval(-3_600)),
        storedDocument("new", modifiedAt: startDate)
      ])
    }
    stubRequest { document in deferredDocument(document.id) }

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(entries["old"]?.nextAttemptAt, startDate.addingTimeInterval(-3_595))
    XCTAssertEqual(entries["new"]?.nextAttemptAt, startDate.addingTimeInterval(5))
    verify(walletKitController, times(1)).requestDeferredIssuance(with: document("old"))
    verify(walletKitController, never()).requestDeferredIssuance(with: document("new"))
  }

  func testCheck_WhenAnEntrysDocumentIsNoLongerDeferred_ThenRemovesTheEntry() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 60), entry("gone", dueIn: -10)])

    await workManager.checkDeferredDocuments()

    let entries = await storage.entries
    XCTAssertEqual(Set(entries.keys), ["a"])
    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenTheEntriesCannotBeRead_ThenAsksNothing() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    await storage.setFailsReads(true)

    await workManager.checkDeferredDocuments()

    verify(walletKitController, never()).requestDeferredIssuance(with: any())
  }

  func testCheck_WhenADeferredReIssueRemovesARevokedDocument_ThenRunsTheRevocationCheck() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .revoked])
      when(mock.fetchAllDocuments()).thenReturn([StubDocument.make(id: "issued-a")])
    }
    stubRequest { _ in StubDocument.make(id: "issued-a") }

    await workManager.checkDeferredDocuments()

    verify(revocationWorkManager).checkAfterReIssue(of: equal(to: "a"))
  }

  func testCheck_WhenNoRevokedDocumentIsRemoved_ThenRunsNoRevocationCheck() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -10)])
    stub(walletKitController) { mock in
      when(mock.fetchAllDocuments()).thenReturn([StubDocument.make(id: "issued-a")])
    }
    stubRequest { _ in StubDocument.make(id: "issued-a") }

    await workManager.checkDeferredDocuments()

    verify(revocationWorkManager, never()).checkAfterReIssue(of: any())
  }

  func testCheck_WhenTheCheckIsCancelled_ThenRecordsNoFailure() async {
    let due = entry("a", dueIn: -10)
    await givenDeferred(["a", "b"], entries: [due, entry("b", dueIn: -5)])
    stubRequest { _ in
      withUnsafeCurrentTask { $0?.cancel() }
      throw CancellationError()
    }
    let manager = workManager!

    await Task { await manager.checkDeferredDocuments() }.value

    let entries = await storage.entries
    XCTAssertEqual(entries["a"], due)
    verify(walletKitController, times(1)).requestDeferredIssuance(with: any())
  }

  // MARK: - The wait

  func testDelayUntilNextCheck_ThenWaitsForTheEarliestPendingEntry() async {
    await storage.setEntries([
      entry("a", dueIn: 100),
      entry("b", dueIn: 40),
      entry("c", dueIn: 1, state: .failed)
    ])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 40)
  }

  func testDelayUntilNextCheck_WhenAnEntryIsOverdue_ThenWaitsTheMinimum() async {
    await storage.setEntries([entry("a", dueIn: -100)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 5)
  }

  func testDelayUntilNextCheck_WhenNoEntryIsPending_ThenThereIsNoNextCheck() async {
    await storage.setEntries([entry("a", dueIn: 10, state: .failed)])

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertNil(delay)
  }

  func testDelayUntilNextCheck_WhenTheEntriesCannotBeRead_ThenReadsAgainLater() async {
    await storage.setFailsReads(true)

    let delay = await workManager.delayUntilNextCheck()

    XCTAssertEqual(delay, 30)
  }

  // MARK: - Starting, waking and stopping

  func testStart_WhenAnEntryIsOverdue_ThenAsksAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: -3_600)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.start()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testWake_WhenIdle_ThenChecksTheEntryAddedMeanwhile() async {
    await workManager.start()
    await waitUntilIdle()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.wake()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testWake_WhenWaitingForALaterEntry_ThenChecksAgainAtOnce() async {
    await givenDeferred(["a"], entries: [entry("a", dueIn: 3_600)])
    let waiting = expectation(description: "waiting")
    waiting.assertForOverFulfill = false
    workManager = makeManager(sleep: { _ in
      waiting.fulfill()
      try await Task.sleep(nanoseconds: 60_000_000_000)
    })
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }
    await workManager.start()
    await fulfillment(of: [waiting], timeout: 2)

    clock.advance(by: 3_600)
    await workManager.wake()

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStart_WhenADocumentIsEnteredLater_ThenChecksIt() async {
    await workManager.start()
    await waitUntilIdle()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    NotificationCenter.default.post(name: .deferredIssuanceEntered, object: nil)

    await fulfillment(of: [asked], timeout: 2)
    await workManager.stop()
  }

  func testStop_ThenAnEnteredDocumentAsksNothing() async {
    await workManager.start()
    await workManager.stop()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    asked.isInverted = true
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    NotificationCenter.default.post(name: .deferredIssuanceEntered, object: nil)

    await fulfillment(of: [asked], timeout: 0.5)
  }

  func testStop_ThenWakeAsksNothing() async {
    await workManager.start()
    await workManager.stop()
    await givenDeferred(["a"], entries: [entry("a", dueIn: -1)])
    let asked = expectation(description: "asked")
    asked.isInverted = true
    stubRequest { _ in
      asked.fulfill()
      throw URLError(.timedOut)
    }

    await workManager.wake()

    await fulfillment(of: [asked], timeout: 0.5)
  }

  func testStop_WhenACheckIsUnderWay_ThenReturnsOnceItHasFinished() async {
    let runner = SerialCheckRunner()
    let manager = makeManager(checkRunner: runner)
    let gate = AsyncGate()
    let started = expectation(description: "started")
    let underWay = Task {
      await runner.run {
        started.fulfill()
        await gate.wait()
      }
    }
    await fulfillment(of: [started], timeout: 5)
    let stoppedEarly = expectation(description: "stopped while it ran")
    stoppedEarly.isInverted = true

    let stopping = Task {
      await manager.stop()
      stoppedEarly.fulfill()
    }

    await fulfillment(of: [stoppedEarly], timeout: 0.5)
    await gate.open()
    await stopping.value
    await underWay.value
  }
}

private extension TestDeferredIssuanceWorkManager {

  func makeManager(
    checkRunner: SerialCheckRunner = SerialCheckRunner(),
    sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { _ in
      try await Task.sleep(nanoseconds: 60_000_000_000)
    }
  ) -> DeferredIssuanceWorkManagerImpl {
    let clock = clock!
    return DeferredIssuanceWorkManagerImpl(
      walletKitController: walletKitController,
      storageController: storage,
      revocationWorkManager: revocationWorkManager,
      checkRunner: checkRunner,
      now: { clock.now },
      sleep: sleep
    )
  }

  /// Polls until the manager's loop has ended.
  func waitUntilIdle() async {
    for _ in 0..<500 {
      if await workManager.isIdle { return }
      try? await Task.sleep(nanoseconds: 10_000_000)
    }
    XCTFail("The manager did not go idle")
  }

  /// Deferred documents for `ids` (named "Document <id>") and the given stored entries.
  func givenDeferred(_ ids: [String], entries: [DeferredIssuance]) async {
    let documents = ids.map { storedDocument($0, modifiedAt: startDate) }
    stub(walletKitController) { mock in
      when(mock.fetchDeferredDocuments()).thenReturn(documents)
    }
    await storage.setEntries(entries)
  }

  func stubRequest(_ answer: @escaping (WalletStorage.Document) throws -> any DocClaimsDecodable) {
    stub(walletKitController) { mock in
      when(mock.requestDeferredIssuance(with: any())).then(answer)
    }
  }

  func entry(
    _ id: String,
    dueIn seconds: TimeInterval,
    interval: TimeInterval? = nil,
    state: DeferredIssuance.State = .pending
  ) -> DeferredIssuance {
    DeferredIssuance(
      identifier: id,
      nextAttemptAt: startDate.addingTimeInterval(seconds),
      interval: interval,
      state: state
    )
  }

  func storedDocument(_ id: String, modifiedAt: Date) -> WalletStorage.Document {
    WalletStorage.Document(
      id: id,
      docType: "eu.europa.ec.eudi.pid.1",
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: modifiedAt,
      modifiedAt: modifiedAt,
      metadata: nil,
      displayName: "Document \(id)",
      status: .deferred
    )
  }

  func document(_ id: String) -> ParameterMatcher<WalletStorage.Document> {
    ParameterMatcher { $0.id == id }
  }
}

/// What WalletKit returns while the credential isn't ready.
private func deferredDocument(_ id: String) -> any DocClaimsDecodable {
  WalletStorage.Document(
    id: id,
    docType: "eu.europa.ec.eudi.pid.1",
    docDataFormat: .cbor,
    data: Data(),
    docKeyInfo: nil,
    createdAt: nil,
    metadata: nil,
    displayName: "Document \(id)",
    status: .deferred
  ).transformToDeferredDecodable()
}

/// Clock that tests can advance.
private final class TestClock: Sendable {

  private let date: OSAllocatedUnfairLock<Date>

  init(_ date: Date) {
    self.date = OSAllocatedUnfairLock(initialState: date)
  }

  var now: Date {
    date.withLock { $0 }
  }

  func advance(by seconds: TimeInterval) {
    date.withLock { $0 = $0.addingTimeInterval(seconds) }
  }
}
