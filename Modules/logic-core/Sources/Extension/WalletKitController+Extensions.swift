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

public extension WalletKitController {
  /// Throws `WalletCoreError.documentBlocked` for a document the issuer has revoked or suspended, and the read's
  /// error when the revocation records cannot be read, so a re-issue fails closed, as the Android wallet does.
  func refuseReIssueIfBlocked(_ identifier: String) async throws {
    guard try await fetchRevokedDocumentStatuses()[identifier] == nil else {
      throw WalletCoreError.documentBlocked
    }
  }
}
