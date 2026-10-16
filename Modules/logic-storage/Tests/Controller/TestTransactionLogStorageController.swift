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
import SwiftData
import os
import logic_business
@testable import logic_storage
@testable import logic_test

final class TestTransactionLogStorageController: EudiTest {

  private var prefsController: StubPrefsController!
  private var swiftDataService: SwiftDataServiceImpl!
  private var controller: TransactionLogStorageControllerImpl!

  override func setUp() {
    super.setUp()
    prefsController = StubPrefsController()
    swiftDataService = SwiftDataServiceImpl(storageConfig: StubStorageConfig())
    controller = TransactionLogStorageControllerImpl(
      swiftDataService: swiftDataService,
      prefsController: prefsController
    )
  }

  override func tearDown() {
    controller = nil
    swiftDataService = nil
    prefsController = nil
    super.tearDown()
  }

  func testRetrieveRevision_WhenTheHistoryIsWrittenOrDeleted_ThenItChangesEachTime() async throws {
    var revisions = [await controller.retrieveRevision()]

    try await controller.store(log("a"))
    revisions.append(await controller.retrieveRevision())
    try await controller.store([log("b"), log("c")])
    revisions.append(await controller.retrieveRevision())
    try await controller.update(log("a"))
    revisions.append(await controller.retrieveRevision())
    try await controller.delete("b")
    revisions.append(await controller.retrieveRevision())
    try await controller.deleteAll()
    revisions.append(await controller.retrieveRevision())

    XCTAssertEqual(Set(revisions).count, revisions.count)
  }

  func testRetrieveRevision_WhenNothingIsWritten_ThenItStaysTheSame() async throws {
    try await controller.store(log("a"))
    let before = await controller.retrieveRevision()

    _ = try await controller.retrieveAll()
    _ = try await controller.retrieve(parentPresentationId: "presentation")

    let after = await controller.retrieveRevision()
    XCTAssertEqual(before, after)
  }

  func testEraseStore_WhenTheStoreHoldsHistory_ThenEmptiesItAndKeepsItUsable() async throws {
    try await controller.store([log("a"), log("b")])

    try await StorageEraseControllerImpl(swiftDataService: swiftDataService).eraseStore()

    do {
      _ = try await controller.retrieveAll()
      XCTFail("Expected an empty store")
    } catch {}
    try await controller.store(log("c"))
    let logs = try await controller.retrieveAll()
    XCTAssertEqual(logs.map(\.identifier), ["c"])
  }

  func testRetrieveAll_WhenTheHistoryExceedsOneBatch_ThenReturnsEveryEntry() async throws {
    try await controller.store((0..<250).map { log("entry-\($0)") })

    let logs = try await controller.retrieveAll()

    XCTAssertEqual(Set(logs.map(\.identifier)).count, 250)
  }

  func testRetrieveParentPresentationId_WhenEntriesBelongToSeveralPresentations_ThenReturnsOnlyThatOnesActions() async throws {
    try await controller.store([
      log("presentation"),
      log("deletion-request", parent: "presentation"),
      log("report", parent: "presentation"),
      log("other-action", parent: "other-presentation")
    ])

    let actions = try await controller.retrieve(parentPresentationId: "presentation")

    XCTAssertEqual(Set(actions.map(\.identifier)), ["deletion-request", "report"])
  }
}

private extension TestTransactionLogStorageController {

  func log(_ identifier: String, parent: String? = nil) -> TransactionLog {
    TransactionLog(identifier: identifier, value: "{}", parentPresentationId: parent)
  }
}

private struct StubStorageConfig: StorageConfig {
  let schemaVersion: UInt64 = 1
  let databaseName = "test"
  let databaseFolder = "Test"
  let databaseExtension = "store"
  var schemas: Schema { StorageConfigImpl().schemas }
  var storeURL: URL { FileManager.default.temporaryDirectory.appendingPathComponent("unused.store") }
  var modelConfiguration: ModelConfiguration { ModelConfiguration(isStoredInMemoryOnly: true) }
}

private final class StubPrefsController: PrefsController {
  private let values = OSAllocatedUnfairLock<[String: Int]>(initialState: [:])

  func setValue(_ value: Any?, forKey: Prefs.Key) {
    let number = value as? Int
    let name = forKey.rawValue
    values.withLock { $0[name] = number }
  }

  func getString(forKey: Prefs.Key) -> String? { nil }

  func getOptionalString(forKey: Prefs.Key) -> String { "" }

  func getBool(forKey: Prefs.Key) -> Bool { false }

  func getFloat(forKey: Prefs.Key) -> Float { 0 }

  func getInt(forKey: Prefs.Key) -> Int {
    let name = forKey.rawValue
    return values.withLock { $0[name] ?? 0 }
  }

  func remove(forKey: Prefs.Key) {
    let name = forKey.rawValue
    values.withLock { $0[name] = nil }
  }

  func getValue(forKey: Prefs.Key) -> Any? {
    let name = forKey.rawValue
    return values.withLock { $0[name] }
  }

  func getUserLocale() -> String { "en" }
}
