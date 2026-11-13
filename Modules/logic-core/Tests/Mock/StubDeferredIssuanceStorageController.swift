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
import logic_storage

/// In-memory entries keyed by document id. Can be made to fail reads.
actor StubDeferredIssuanceStorageController: DeferredIssuanceStorageController {

  struct ReadFailure: Error {}

  private(set) var entries: [String: DeferredIssuance] = [:]
  private var failsReads = false

  init(_ entries: [DeferredIssuance] = []) {
    self.entries = Dictionary(uniqueKeysWithValues: entries.map { ($0.identifier, $0) })
  }

  func setEntries(_ entries: [DeferredIssuance]) {
    self.entries = Dictionary(uniqueKeysWithValues: entries.map { ($0.identifier, $0) })
  }

  func setFailsReads(_ failsReads: Bool) {
    self.failsReads = failsReads
  }

  func store(_ value: DeferredIssuance) async throws {
    entries[value.identifier] = value
  }

  func store(_ values: [DeferredIssuance]) async throws {
    values.forEach { entries[$0.identifier] = $0 }
  }

  func update(_ value: DeferredIssuance) async throws {
    entries[value.identifier] = value
  }

  func retrieve(_ identifier: String) async throws -> DeferredIssuance {
    guard !failsReads else { throw ReadFailure() }
    guard let entry = entries[identifier] else { throw StorageError.itemNotFound }
    return entry
  }

  func retrieveAll() async throws -> [DeferredIssuance] {
    guard !failsReads else { throw ReadFailure() }
    guard !entries.isEmpty else { throw StorageError.itemsNotFound }
    return Array(entries.values)
  }

  func delete(_ identifier: String) async throws {
    entries[identifier] = nil
  }

  func deleteAll() async throws {
    entries = [:]
  }
}
