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
    XCTAssertEqual(data.primary.isVerified, true)
    XCTAssertEqual(data.intendedUse, .custom("Onboarding"))
    XCTAssertNil(registration.toWarning())
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
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertEqual(registration.toWarning(), .relyingPartyNotVerified)
  }

  func testToRegistrationData_whenNotSupported_thenStillNamesTheRequester() {
    // Given a transport without registration certificates, the requester is still identified and
    // the badge falls back to access-certificate trust; only the certificate's sections are absent
    let registration = relyingParty(status: .notSupported)

    // When
    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    // Then
    XCTAssertEqual(data.primary.name, .custom("NordicBank A/S"))
    XCTAssertEqual(data.primary.isVerified, registration.isVerified)
    XCTAssertNil(data.intendedUse)
    XCTAssertNil(data.privacyPolicyUrl)
    XCTAssertNil(registration.toWarning())
  }

  func testToRegistrationData_whenNotVerified_thenStillNamesTheRequester() {
    // The party whose registration failed is the one the user most needs identified
    let registration = relyingParty(status: .notVerified)

    let data = registration.toRegistrationData(fallbackName: .unknownVerifier)

    XCTAssertEqual(data.primary.name, .custom("NordicBank A/S"))
    XCTAssertEqual(data.primary.isVerified, false)
  }

  func testIssuerToRegistrationData_whenCertificateHasNoLogo_thenFallsBackToIssuerMetadata() {
    let metadataLogo = URL(string: "https://issuer.example/logo.png")
    let registration: IssuerRegistration? = .verified(details: details())

    let data = registration.toRegistrationData(issuerName: "Aegean S.A.", issuerLogo: metadataLogo)

    XCTAssertEqual(data.primary.logoUrl, metadataLogo)
  }

  func testIssuerToRegistrationData_whenCertificateCarriesALogo_thenItWinsOverMetadata() {
    let certificateLogo = URL(string: "https://registry.example/certified-logo.png")
    let registration: IssuerRegistration? = .verified(details: details(logoUrl: certificateLogo))

    let data = registration.toRegistrationData(
      issuerName: "Aegean S.A.",
      issuerLogo: URL(string: "https://issuer.example/logo.png")
    )

    XCTAssertEqual(data.primary.logoUrl, certificateLogo)
  }

  func testIssuerToRegistrationData_whenBlocked_thenStillNamesTheIssuer() {
    // The offer names the issuer, so a refused registration does not erase who made the offer
    let registration: IssuerRegistration? = .blocked(reason: .attestationNotRegistered)

    let data = registration.toRegistrationData(issuerName: "Aegean S.A.")

    XCTAssertEqual(data.primary.name, .custom("Aegean S.A."))
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertNil(data.primary.identifier)
    XCTAssertNil(data.intendedUse)
  }

  func testIssuerToRegistrationData_whenNotEvaluated_thenStillNamesTheIssuer() {
    // Validation switched off: nothing was checked, but the offer still says who is offering
    let registration: IssuerRegistration? = nil
    let metadataLogo = URL(string: "https://issuer.example/logo.png")

    let data = registration.toRegistrationData(issuerName: "Aegean S.A.", issuerLogo: metadataLogo)

    XCTAssertEqual(data.primary.name, .custom("Aegean S.A."))
    XCTAssertEqual(data.primary.logoUrl, metadataLogo)
    XCTAssertEqual(data.primary.isVerified, false)
    XCTAssertNil(data.privacyPolicyUrl)
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

  func details(logoUrl: URL? = nil) -> RegistrationDetails {
    RegistrationDetails(
      tradeName: "NordicBank A/S",
      uniqueId: "rp:nordicbank:prod",
      logoUrl: logoUrl,
      intendedUse: "Onboarding",
      privacyPolicyUrl: URL(string: "https://nordicbank.example/privacy"),
      serviceDescription: "Current account onboarding"
    )
  }
}
