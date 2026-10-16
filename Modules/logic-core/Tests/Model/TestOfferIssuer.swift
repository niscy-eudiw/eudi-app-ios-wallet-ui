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
@testable import logic_core
@testable import logic_test

final class TestOfferIssuer: EudiTest {

  private let configured = ["https://issuer.example", "https://backend.example:8443"]

  func testOf_WhenTheOfferByValueNamesAConfiguredIssuer_ThenReturnsIt() {
    let issuer = OfferIssuer.of(offerUri: byValue(issuer: "https://issuer.example"), configuredIssuers: configured)

    XCTAssertEqual(issuer, .configured("https://issuer.example"))
  }

  func testOf_WhenTheOfferByValueNamesAnotherIssuer_ThenIsNotConfigured() {
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byValue(issuer: "https://attacker.example"), configuredIssuers: configured),
      .notConfigured
    )
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byValue(issuer: "https://issuer.example/"), configuredIssuers: configured),
      .notConfigured
    )
  }

  func testOf_WhenTheOfferByReferenceIsOnAConfiguredIssuersOrigin_ThenReturnsThatIssuer() {
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byReference("https://ISSUER.example/offers/1"), configuredIssuers: configured),
      .configured("https://issuer.example")
    )
    XCTAssertEqual(
      OfferIssuer.of(offerUri: byReference("https://backend.example:8443/offer"), configuredIssuers: configured),
      .configured("https://backend.example:8443")
    )
  }

  func testOf_WhenTheOfferByReferenceIsElsewhereOrNotHttps_ThenIsNotConfigured() {
    for address in [
      "https://attacker.example/offer",
      "http://issuer.example/offer",
      "https://backend.example/offer",
      "https://issuer.example:8443/offer"
    ] {
      XCTAssertEqual(
        OfferIssuer.of(offerUri: byReference(address), configuredIssuers: configured),
        .notConfigured,
        address
      )
    }
  }

  func testOf_WhenTheLinkCarriesNoOfferOrMoreThanOne_ThenIsUnreadable() {
    let both = byValue(issuer: "https://issuer.example") + "&credential_offer_uri=https://issuer.example/o"
    for link in ["openid-credential-offer://?foo=bar", both, byReference("https://issuer.example/a") + "&CREDENTIAL_OFFER_URI=x"] {
      XCTAssertEqual(OfferIssuer.of(offerUri: link, configuredIssuers: configured), .unreadable, link)
    }
    XCTAssertEqual(
      OfferIssuer.of(offerUri: "openid-credential-offer://?credential_offer=not-json", configuredIssuers: configured),
      .unreadable
    )
  }

  func testRequireConfigured_WhenTheIssuerIsNotConfigured_ThenThrowsIssuerNotConfigured() {
    XCTAssertThrowsError(
      try OfferIssuer.requireConfigured(offerUri: byValue(issuer: "https://attacker.example"), configuredIssuers: configured)
    ) { error in
      XCTAssertEqual(error.localizedDescription, WalletCoreError.issuerNotConfigured.localizedDescription)
    }
  }

  func testRequireConfigured_WhenTheIssuerIsConfigured_ThenPasses() {
    XCTAssertNoThrow(
      try OfferIssuer.requireConfigured(offerUri: byValue(issuer: "https://issuer.example"), configuredIssuers: configured)
    )
  }
}

private extension TestOfferIssuer {

  func byValue(issuer: String) -> String {
    let json = "{\"credential_issuer\":\"\(issuer)\",\"credential_configuration_ids\":[\"pid\"]}"
    return "openid-credential-offer://?credential_offer="
      + (json.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")
  }

  func byReference(_ address: String) -> String {
    "openid-credential-offer://?credential_offer_uri="
      + (address.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")
  }
}
