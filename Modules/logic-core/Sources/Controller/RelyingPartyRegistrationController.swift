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

public enum RegistrationTransport: Sendable {
  case openId4Vp
  case proximity
}

public protocol RelyingPartyRegistrationController: Sendable {

  /// Registration evaluation of the verifier behind the current presentation request.
  ///
  /// - Parameters:
  ///   - verifierName: the verifier's access-certificate name, as received.
  ///   - verifierIsTrusted: whether the verifier's access-certificate chain is trusted.
  ///   - transport: how the request arrived; `.proximity` carries no registration certificate.
  ///   - requestedClaims: every claim the request asks for, for overasked detection.
  func getVerifierRegistration(
    verifierName: String?,
    verifierIsTrusted: Bool,
    transport: RegistrationTransport,
    requestedClaims: [RequestedClaim]
  ) -> RelyingPartyRegistration

  func getIssuerRegistration(issuerId: String) -> IssuerRegistration
}

public enum MockVerifierRegistrationScenario: Sendable {
  case verified
  case notVerified
  case overasked
  case intermediary
}

public enum MockIssuerRegistrationScenario: Sendable {
  case verified
  case notVerified
  case blockedNotRegisteredAsProvider
  case blockedAttestationNotRegistered
}

public final class MockRelyingPartyRegistrationControllerImpl: RelyingPartyRegistrationController {

  private let verifierScenario: MockVerifierRegistrationScenario
  private let issuerScenario: MockIssuerRegistrationScenario

  public init(
    verifierScenario: MockVerifierRegistrationScenario,
    issuerScenario: MockIssuerRegistrationScenario
  ) {
    self.verifierScenario = verifierScenario
    self.issuerScenario = issuerScenario
  }

  public func getVerifierRegistration(
    verifierName: String?,
    verifierIsTrusted: Bool,
    transport: RegistrationTransport,
    requestedClaims: [RequestedClaim]
  ) -> RelyingPartyRegistration {

    guard transport == .openId4Vp else {
      return RelyingPartyRegistration(
        name: verifierName,
        uniqueId: nil,
        isVerified: verifierIsTrusted,
        logoUrl: nil,
        registration: .notSupported
      )
    }

    return switch verifierScenario {
    case .verified:
      RelyingPartyRegistration(
        name: verifierName,
        uniqueId: Self.nordicBankUniqueId,
        isVerified: verifierIsTrusted,
        logoUrl: Self.nordicBankLogoUrl,
        registration: .verified(details: Self.nordicBankDetails, overaskedClaims: [])
      )

    case .notVerified:
      RelyingPartyRegistration(
        name: verifierName,
        uniqueId: Self.acmeUniqueId,
        isVerified: verifierIsTrusted,
        logoUrl: nil,
        registration: .notVerified
      )

    case .overasked:
      RelyingPartyRegistration(
        name: verifierName,
        uniqueId: Self.nordicBankUniqueId,
        isVerified: verifierIsTrusted,
        logoUrl: Self.nordicBankLogoUrl,
        registration: .verified(
          details: Self.nordicBankDetails,
          overaskedClaims: Array(requestedClaims.prefix(1))
        )
      )

    case .intermediary:
      RelyingPartyRegistration(
        name: verifierName,
        uniqueId: Self.rpServicesUniqueId,
        isVerified: verifierIsTrusted,
        logoUrl: Self.rpServicesLogoUrl,
        registration: .verified(
          details: Self.intermediatedNordicBankDetails,
          overaskedClaims: []
        )
      )
    }
  }

  public func getIssuerRegistration(issuerId: String) -> IssuerRegistration {
    return switch issuerScenario {
    case .verified:
      .verified(details: Self.aegeanDetails)
    case .notVerified:
      .notVerified
    case .blockedNotRegisteredAsProvider:
      .blocked(reason: .notRegisteredAsProvider)
    case .blockedAttestationNotRegistered:
      .blocked(reason: .attestationNotRegistered)
    }
  }
}

private extension MockRelyingPartyRegistrationControllerImpl {

  static let nordicBankUniqueId = "rp:nordicbank:prod"
  static let acmeUniqueId = "rp:acme:prod"
  static let rpServicesUniqueId = "rp:rpservices:prod"

  static let nordicBankLogoUrl = URL(string: "https://nordicbank.example/logo.png")
  static let rpServicesLogoUrl = URL(string: "https://rpservices.example/logo.png")

  static let nordicBankDetails = RegistrationDetails(
    tradeName: "NordicBank A/S",
    uniqueId: nordicBankUniqueId,
    logoUrl: nordicBankLogoUrl,
    intendedUse: """
    We will use your identity and age to verify you for a new current account. Your data will be \
    used once to complete onboarding and to meet anti-money laundering requirements.
    """,
    privacyPolicyUrl: URL(string: "https://nordicbank.example/privacy"),
    serviceDescription: "Current account onboarding",
    isIntermediated: false
  )

  static let intermediatedNordicBankDetails = RegistrationDetails(
    tradeName: nordicBankDetails.tradeName,
    uniqueId: nordicBankDetails.uniqueId,
    logoUrl: nordicBankDetails.logoUrl,
    intendedUse: nordicBankDetails.intendedUse,
    privacyPolicyUrl: nordicBankDetails.privacyPolicyUrl,
    serviceDescription: nordicBankDetails.serviceDescription,
    isIntermediated: true
  )

  static let aegeanDetails = RegistrationDetails(
    tradeName: "Aegean S.A.",
    uniqueId: "rp:aegeanairlines:prod",
    logoUrl: URL(string: "https://aegean.gr/logo.png"),
    intendedUse: "Aegean Airlines is asking your permission to issue the following to your Wallet.",
    privacyPolicyUrl: URL(string: "https://aegean.gr/privacy"),
    serviceDescription: "Boarding pass issuance",
    isIntermediated: false
  )
}
