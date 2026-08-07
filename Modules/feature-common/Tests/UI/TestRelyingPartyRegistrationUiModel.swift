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
import logic_core
import logic_resources
@testable import feature_common
@testable import logic_test

final class TestRelyingPartyRegistrationUiModel: EudiTest {

  func testToRegistrationData_whenVerified_thenShowsRegistrationAndNoWarning() {
    // Given
    let registration = relyingParty(status: .verified(details: details(), overaskedClaims: []))

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data?.primary.isVerified, true)
    XCTAssertEqual(data?.intendedUse, .custom("Onboarding"))
    XCTAssertNil(data?.onBehalfOf)
    XCTAssertNil(registration.toWarning())
  }

  func testToRegistrationData_whenIntermediated_thenFillsOnBehalfOfBlock() {
    // Given
    let registration = relyingParty(
      status: .verified(details: details(isIntermediated: true), overaskedClaims: [])
    )

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data?.onBehalfOf?.name, .custom("NordicBank A/S"))
    XCTAssertEqual(data?.onBehalfOf?.isVerified, true)
  }

  func testToWarning_whenOverasked_thenReturnsOveraskedWarning() {
    // Given
    let registration = relyingParty(
      status: .verified(
        details: details(),
        overaskedClaims: [RequestedClaim(queryId: "doc-id", path: ["namespace", "age"])]
      )
    )

    // When / Then
    XCTAssertEqual(registration.toWarning(), .relyingPartyOverasked)
  }

  func testToWarning_whenNotVerified_thenReturnsNotVerifiedWarning() {
    // Given
    let registration = relyingParty(status: .notVerified)

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data?.primary.isVerified, false)
    XCTAssertEqual(registration.toWarning(), .relyingPartyNotVerified)
  }

  func testToRegistrationData_whenNotSupported_thenNoBlockAndNoWarning() {
    // Given a transport without registration certificates, the badge falls back to
    // access-certificate trust and nothing new is shown
    let registration = relyingParty(status: .notSupported)

    // When / Then
    XCTAssertNil(registration.toRegistrationData(fallbackName: .unknownVerifier))
    XCTAssertNil(registration.toWarning())
  }

  func testIssuerToRegistrationData_whenCertificateHasNoLogo_thenFallsBackToIssuerMetadata() {
    let metadataLogo = URL(string: "https://issuer.example/logo.png")
    let registration = IssuerRegistration.verified(details: details())

    let data = registration.toRegistrationData(issuerName: "Aegean S.A.", issuerLogo: metadataLogo)

    XCTAssertEqual(data?.primary.logoUrl, metadataLogo)
  }

  func testIssuerToRegistrationData_whenCertificateCarriesALogo_thenItWinsOverMetadata() {
    let certificateLogo = URL(string: "https://registry.example/certified-logo.png")
    let registration = IssuerRegistration.verified(details: details(logoUrl: certificateLogo))

    let data = registration.toRegistrationData(
      issuerName: "Aegean S.A.",
      issuerLogo: URL(string: "https://issuer.example/logo.png")
    )

    XCTAssertEqual(data?.primary.logoUrl, certificateLogo)
  }

  func testIssuerToRegistrationData_whenBlocked_thenNoBlockIsShown() {
    let registration = IssuerRegistration.blocked(reason: .attestationNotRegistered)

    XCTAssertNil(registration.toRegistrationData(issuerName: "Aegean S.A."))
  }

  func testIssuerToWarning_whenNotVerified_thenReturnsIssuerWarning() {
    XCTAssertEqual(IssuerRegistration.notVerified.toWarning(), .issuerNotVerified)
    XCTAssertNil(IssuerRegistration.verified(details: details()).toWarning())
    XCTAssertNil(
      IssuerRegistration.blocked(reason: .notRegisteredAsProvider).toWarning()
    )
  }
}

private extension TestRelyingPartyRegistrationUiModel {

  func relyingParty(status: RegistrationStatus) -> RelyingPartyRegistration {
    RelyingPartyRegistration(
      name: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      isVerified: true,
      logoUrl: nil,
      registration: status
    )
  }

  func details(isIntermediated: Bool = false, logoUrl: URL? = nil) -> RegistrationDetails {
    RegistrationDetails(
      tradeName: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      logoUrl: logoUrl,
      intendedUse: "Onboarding",
      privacyPolicyUrl: URL(string: "https://nordicbank.example/privacy"),
      serviceDescription: "Current account onboarding",
      isIntermediated: isIntermediated
    )
  }
}
