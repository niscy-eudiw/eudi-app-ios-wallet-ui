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
import logic_storage
@testable import logic_core
@testable import logic_test

final class TestWalletKitControllerDeferredIssuance: EudiTest {

  private var storage: StubDeferredIssuanceStorageController!
  private var controller: WalletKitControllerImpl!

  override func setUp() {
    super.setUp()
    storage = StubDeferredIssuanceStorageController()
    controller = TestWalletKitControllerOffer.makeController(
      issuer: "https://issuer.example",
      deferredIssuanceStorageController: storage
    )
  }

  override func tearDown() {
    controller = nil
    storage = nil
    super.tearDown()
  }

  func testFetchFailedDeferredDocumentIds_WhenTheIssuerRefusedSome_ThenReturnsOnlyThose() async {
    await storage.setEntries([entry("a", state: .pending), entry("b", state: .failed), entry("c", state: .failed)])

    let ids = await controller.fetchFailedDeferredDocumentIds()

    XCTAssertEqual(ids, ["b", "c"])
  }

  func testFetchFailedDeferredDocumentIds_WhenThereIsNoEntry_ThenReturnsNone() async {
    let ids = await controller.fetchFailedDeferredDocumentIds()

    XCTAssertEqual(ids, [])
  }

  func testFetchFailedDeferredDocumentIds_WhenTheEntriesCannotBeRead_ThenReturnsNoneSoTheyShowAsPending() async {
    await storage.setEntries([entry("b", state: .failed)])
    await storage.setFailsReads(true)

    let ids = await controller.fetchFailedDeferredDocumentIds()

    XCTAssertEqual(ids, [])
  }

  func testDeleteAllRecords_ThenRemovesEveryDeferredEntry() async throws {
    await storage.setEntries([entry("a", state: .pending), entry("b", state: .failed)])

    try await controller.deleteAllRecords()

    let entries = await storage.entries
    XCTAssertTrue(entries.isEmpty)
  }
}

private extension TestWalletKitControllerDeferredIssuance {

  func entry(_ id: String, state: DeferredIssuance.State) -> DeferredIssuance {
    DeferredIssuance(identifier: id, nextAttemptAt: Date(timeIntervalSince1970: 0), state: state)
  }
}
