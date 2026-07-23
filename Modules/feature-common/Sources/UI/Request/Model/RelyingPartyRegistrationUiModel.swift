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
import logic_core
import logic_ui
import logic_resources

public enum RegistrationWarning: Sendable, Equatable {

  case relyingPartyNotVerified
  case relyingPartyOverasked
  case issuerNotVerified

  public var message: LocalizableStringKey {
    return switch self {
    case .relyingPartyNotVerified: .relyingPartyNotVerifiedWarning
    case .relyingPartyOverasked: .relyingPartyOveraskedWarning
    case .issuerNotVerified: .issuerNotVerifiedWarning
    }
  }

  public var acknowledgement: LocalizableStringKey {
    return switch self {
    case .relyingPartyNotVerified, .relyingPartyOverasked: .understandRisksAgree
    case .issuerNotVerified: .understandRisksProceed
    }
  }
}

public extension RelyingPartyRegistration {

  func toRegistrationData(fallbackName: LocalizableStringKey) -> RelyingPartyRegistrationData? {
    let showVerifiedBadge = switch registration {
    case .verified: true
    case .notVerified: false
    case .notSupported: isVerified
    }

    guard registration != .notSupported else { return nil }

    let details = registration.details

    let onBehalfOf = details.flatMap { safeDetails in
      safeDetails.isIntermediated
      ? RegisteredParty(
        name: .custom(safeDetails.tradeName),
        identifier: .relyingPartyId([safeDetails.uniqueId]),
        isVerified: true
      )
      : nil
    }

    return RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: name.map { LocalizableStringKey.custom($0) } ?? fallbackName,
        identifier: uniqueId.map { LocalizableStringKey.relyingPartyId([$0]) },
        isVerified: showVerifiedBadge
      ),
      onBehalfOf: onBehalfOf,
      privacyPolicyUrl: details?.privacyPolicyUrl,
      intendedUse: details?.intendedUse.map { LocalizableStringKey.custom($0) }
    )
  }

  func toWarning() -> RegistrationWarning? {
    return switch registration {
    case .verified(_, let overaskedClaims):
      overaskedClaims.isEmpty ? nil : .relyingPartyOverasked
    case .notVerified:
      .relyingPartyNotVerified
    case .notSupported:
      nil
    }
  }
}

public extension IssuerRegistration {

  func toRegistrationData(issuerName: String) -> RelyingPartyRegistrationData? {
    guard let details else { return nil }
    return RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: .custom(issuerName),
        identifier: .relyingPartyId([details.uniqueId]),
        isVerified: true
      ),
      privacyPolicyUrl: details.privacyPolicyUrl,
      intendedUse: details.intendedUse.map { LocalizableStringKey.custom($0) }
    )
  }

  func toWarning() -> RegistrationWarning? {
    return switch self {
    case .verified: nil
    case .notVerified: .issuerNotVerified
    case .blocked: nil
    }
  }
}
