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
import UIKit

public extension URL {

  /// True for an `https` link with a host, the only kind of address a relying party or an issuer may
  /// send the user to. As Android's `isOpenableExternalLink`.
  var isHttpsWebLink: Bool {
    scheme?.lowercased() == "https" && !(host ?? "").isEmpty
  }

  /// Opens the link in the browser if it is an `https` link with a host, and does nothing otherwise. It
  /// never passes the link to the wallet's own link handling. The reference app claims no associated
  /// domains; one that does must keep its domains out of the links it opens this way, because iOS would
  /// hand such a link back to the wallet.
  @MainActor func openInBrowser(using open: @MainActor (URL) -> Void = { UIApplication.shared.open($0) }) {
    guard isHttpsWebLink else { return }
    open(self)
  }
}
