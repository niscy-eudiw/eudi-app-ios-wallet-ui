/*
 * Copyright (c) 2025 European Commission
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
import logic_ui

public struct DocumentSuccessUIConfig: UIConfigType, Equatable {

  public let successNavigation: UIConfig.DeepLinkNavigationType
  public let relyingParty: String?
  public let issuerLogoUrl: URL?
  public let relyingPartyIsTrusted: Bool

  public var log: String {
    return "onSuccessNav: \(successNavigation.type)" +
    " relyingParty: \(relyingParty ?? "")"
  }

  public init(
    successNavigation: UIConfig.DeepLinkNavigationType,
    relyingParty: String? = nil,
    issuerLogoUrl: URL? = nil,
    relyingPartyIsTrusted: Bool
  ) {
    self.successNavigation = successNavigation
    self.relyingParty = relyingParty
    self.relyingPartyIsTrusted = relyingPartyIsTrusted
    self.issuerLogoUrl = issuerLogoUrl
  }
}
