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

/// Payload of `DeferredIssuanceResult`: issued and refused documents, id → display name.
/// Issued documents are keyed by the id of the issued document, which can differ from the deferred one.
public struct DeferredIssuancePayload: Sendable, Equatable {

  public let issued: [String: String]
  public let failed: [String: String]

  public init(issued: [String: String], failed: [String: String]) {
    self.issued = issued
    self.failed = failed
  }

  /// nil if the shape is wrong or both lists are empty.
  public init?(userInfo: [AnyHashable: Any]?) {
    guard
      let issued = userInfo?[Keys.issued] as? [String: String],
      let failed = userInfo?[Keys.failed] as? [String: String],
      !issued.isEmpty || !failed.isEmpty
    else {
      return nil
    }
    self.init(issued: issued, failed: failed)
  }

  public var userInfo: [AnyHashable: Any] {
    [
      Keys.issued: issued,
      Keys.failed: failed
    ]
  }
}

private extension DeferredIssuancePayload {
  enum Keys {
    static let issued = "issued"
    static let failed = "failed"
  }
}
