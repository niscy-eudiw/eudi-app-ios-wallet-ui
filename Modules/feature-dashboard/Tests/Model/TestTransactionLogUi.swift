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
@testable import logic_resources
@testable import logic_ui
@testable import logic_test
@testable import feature_test
@testable import feature_dashboard

final class TestTransactionLogUi: EudiTest {
  private let time = Date(timeIntervalSince1970: 1_700_000_000)
  private let noParty = InteractingPartyDomain(name: nil, identifier: nil, contacts: [])

  func testTransformToTransactionUI_WhenPresentation_ThenUsesPartyNameAndType() {
    let ui = Constants.eudiRemoteVerifierMock.transformToTransactionUI()

    XCTAssertEqual(ui?.id, "transactionId1")
    XCTAssertEqual(ui?.name, "EUDI Remote Verifier")
    XCTAssertEqual(ui?.status, .completed)
    XCTAssertEqual(ui?.transactionType, .presentation)
  }

  func testTransformToTransactionUI_WhenPresentationHasNoParty_ThenFallsBackToTypeLabel() {
    let log = TransactionLogDomain.presentation(
      .init(id: "1", time: time, result: .notCompleted(reason: nil), party: noParty, intermediary: nil, registration: nil, claimsRequested: [], claimsPresented: [])
    )

    let ui = log.transformToTransactionUI()

    XCTAssertEqual(ui?.name, TransactionType.presentation.typeTitle.toString)
    XCTAssertEqual(ui?.status, .notCompleted)
  }

  func testTransformToTransactionUI_WhenIssuanceHasNoIssuerName_ThenUsesCredentialIdentifier() {
    let log = TransactionLogDomain.credentialIssuance(
      .init(id: "2", time: time, result: .completed, details: .init(issuer: noParty, issuerType: nil, requestedCount: 1, issuedCount: 1, credentials: [.init(identifier: .sdJwtPid)], isUserTriggered: nil))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, DocumentTypeIdentifier.sdJwtPid.rawValue)
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .issuance)
  }

  func testTransformToTransactionUI_WhenReissuance_ThenTypeIsReissuance() {
    let log = TransactionLogDomain.credentialReissuance(
      .init(id: "3", time: time, result: .completed, details: .init(issuer: .init(name: "Issuer", identifier: nil, contacts: []), issuerType: nil, requestedCount: 1, issuedCount: 1, credentials: [], isUserTriggered: false))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "Issuer")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .reissuance)
  }

  func testTransformToTransactionUI_WhenDeletion_ThenTitleIsTheIssuer() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: .init(name: "Issuer", identifier: nil, contacts: []))
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "Issuer")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenDeletionHasNoIssuerName_ThenUsesTheCredential() {
    let log = TransactionLogDomain.credentialDeletion(
      .init(id: "4", time: time, result: .completed, credential: .init(identifier: .mDocPid), issuer: noParty)
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, DocumentTypeIdentifier.mDocPid.rawValue)
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .deletion)
  }

  func testTransformToTransactionUI_WhenSigningHasNoServiceName_ThenUsesFileName() {
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: noParty, certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    XCTAssertEqual(log.transformToTransactionUI()?.name, "contract.pdf")
    XCTAssertEqual(log.transformToTransactionUI()?.transactionType, .signing)
  }

  func testTransformToTransactionUI_WhenPresentationAction_ThenHiddenFromList() {
    let request = TransactionLogDomain.dataDeletionRequest(
      .init(id: "6", time: time, result: .completed, parentPresentationId: "1", party: noParty, claims: [])
    )
    let report = TransactionLogDomain.dpaReport(
      .init(id: "7", time: time, result: .completed, parentPresentationId: "1", dpaName: "DPA", dpaCountry: nil)
    )

    XCTAssertNil(request.transformToTransactionUI())
    XCTAssertNil(report.transformToTransactionUI())
  }

  func testSearchTags_WhenPresentationHasIntermediary_ThenBothNamesAreSearchable() {
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: " Verifier ", identifier: nil, contacts: []),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: nil, claimsRequested: [], claimsPresented: []
      )
    )

    XCTAssertEqual(log.searchTags, ["Verifier", "Broker"])
  }

  func testSearchTags_WhenSigning_ThenServiceAndFileNameAreSearchable() {
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: .init(name: "QTSP", identifier: nil, contacts: []), certificateSerialNumber: nil, fileName: "contract.pdf", fileSizeBytes: nil, dtbsr: nil)
    )

    XCTAssertEqual(log.searchTags, ["QTSP", "contract.pdf"])
  }

  func testIdentifierPath_WhenSegmentsAreMixed_ThenRendersBracketedComponents() {
    let claim = ClaimRefDomain(segments: [.key(name: "addresses"), .allElements, .key(name: "street"), .index(2)])

    XCTAssertEqual(claim.identifierPath, .custom(#"["addresses"][*]["street"][2]"#))
    XCTAssertEqual(ClaimRefDomain(segments: []).identifierPath, .transactionDetailsUnknownClaim)
  }

  func testToUiModel_WhenIssuance_ThenBuildsIssuerIssuanceAndCredentialSections() {
    let log = TransactionLogDomain.credentialIssuance(
      .init(
        id: "2", time: time, result: .notCompleted(reason: "Not all requested credentials were issued"),
        details: .init(
          issuer: .init(name: "PID Provider", identifier: .init(schemeUri: "http://data.europa.eu/eudi/id/LEI", value: "123"), contacts: ["https://issuer.example"]),
          issuerType: "PIDProvider", requestedCount: 5, issuedCount: 3,
          credentials: [.init(identifier: .mDocPid)], isUserTriggered: true
        )
      )
    )

    let ui = log.toUiModel()

    XCTAssertEqual(ui.sections.map(\.id), ["issuance", "credentials"])
    XCTAssertEqual(ui.transactionDetailsCardData.partyLabel, .transactionDetailsIssuerLabel)
    XCTAssertEqual(ui.transactionDetailsCardData.partyName, .custom("PID Provider"))
    XCTAssertEqual(ui.transactionDetailsCardData.partySubtitles, [.custom("123")])
    XCTAssertEqual(ui.transactionDetailsCardData.details.map { $0.map(\.id) }, [["issuer:scheme", "issuer:contact:0", "issuer:type"]])
    XCTAssertNotNil(ui.transactionDetailsCardData.details[0][1].url)
    XCTAssertEqual(ui.sections[0].fields.map(\.id), ["issuance:count", "issuance:trigger"])
    XCTAssertEqual(ui.sections[1].fields.first?.listItem.mainContent, .text(.custom(DocumentTypeIdentifier.mDocPid.rawValue)))
    XCTAssertEqual(ui.transactionDetailsCardData.nonCompletionReason, .custom("Not all requested credentials were issued"))
    XCTAssertFalse(ui.showsPresentationActions)
  }

  func testToUiModel_WhenSigning_ThenDigestIsCollapsedInTechnicalSection() {
    let log = TransactionLogDomain.signingSealing(
      .init(id: "5", time: time, result: .completed, service: .init(name: "QTSP", identifier: nil, contacts: []), certificateSerialNumber: "serial", fileName: "contract.pdf", fileSizeBytes: 2048, dtbsr: "ZGlnZXN0")
    )

    let ui = log.toUiModel()

    XCTAssertEqual(ui.sections.map(\.id), ["document", "technical"])
    XCTAssertEqual(ui.transactionDetailsCardData.partyLabel, .transactionDetailsSigningServiceLabel)
    XCTAssertEqual(ui.transactionDetailsCardData.details.map { $0.map(\.id) }, [["service:certificate"]])
    XCTAssertEqual(ui.sections[0].fields.map(\.id), ["document:name", "document:size"])
    XCTAssertEqual(ui.sections[1].groups.count, 1)
  }

  func testContacts_WhenNothingWasPresented_ThenDeletionCannotBeRequested() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .notCompleted(reason: nil),
      party: .init(name: "Verifier", identifier: nil, contacts: ["support@verifier.example", "not a contact"]),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "DPA", country: nil, contacts: ["+30 210 1234567", "https://dpa.example"])),
      claimsRequested: [], claimsPresented: []
    )

    XCTAssertTrue(presentation.contacts(for: .requestDataDeletion).isEmpty)
    XCTAssertEqual(
      presentation.contacts(for: .reportSuspiciousTransaction).map(\.url),
      [URL(string: "https://dpa.example")!, URL(string: "tel:+302101234567")!]
    )
  }

  func testToActionUiModel_WhenContactsAreMixed_ThenKindsFollowTheUrlScheme() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil,
      registration: .init(registrarUrl: nil, purpose: nil, privacyPolicyUrls: [], dpa: .init(name: "APD-GBA", country: "BE", contacts: ["+32 2 274 48 00", "contact@apd-gba.be", "https://www.autoriteprotectiondonnees.be"])),
      claimsRequested: [], claimsPresented: []
    )

    let ui = presentation.toActionUiModel(transactionId: "1", action: .reportSuspiciousTransaction)

    guard case .contactList(let content) = ui.content else {
      return XCTFail("Expected the contact list layout for a report.")
    }
    XCTAssertEqual(content.partyName, .custom("APD-GBA"))
    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    XCTAssertEqual(ui.contacts.map(\.label), ["https://www.autoriteprotectiondonnees.be", "contact@apd-gba.be", "+32 2 274 48 00"])
    XCTAssertEqual(content.followUp, .transactionActionReportFollowUp(["APD-GBA"]))
  }

  func testContacts_WhenSeveralMethodsExist_ThenWebsiteComesFirstAndPhoneLast() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example", "https://verifier.example/erasure"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    let ui = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion)

    XCTAssertEqual(ui.contacts.map(\.channel), [.website, .email, .phone])
    guard case .confirmation(let content) = ui.content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroWebsite(["Verifier"]))
    XCTAssertEqual(content.contact?.channel, .website)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueWebsite(["Verifier"]))
  }

  func testDeletionScreen_WhenThereIsNoWebsite_ThenEmailIsPreferredOverPhone() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567", "support@verifier.example"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .email)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinueEmail)
  }

  func testDeletionScreen_WhenOnlyAPhoneExists_ThenItIsUsed() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: ["+30 210 1234567"]),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertEqual(content.contact?.channel, .phone)
    XCTAssertEqual(content.buttonTitle, .transactionActionContinuePhone(["Verifier"]))
    XCTAssertEqual(content.intro, .transactionActionDeletionIntroPhone(["Verifier"]))
  }

  func testDeletionScreen_WhenNoContactIsRecorded_ThenTheButtonIsDisabled() {
    let presentation = TransactionLogDomain.Presentation(
      id: "1", time: time, result: .completed,
      party: .init(name: "Verifier", identifier: nil, contacts: []),
      intermediary: nil, registration: nil,
      claimsRequested: [],
      claimsPresented: [.init(credential: .init(identifier: .mDocPid), claims: [])]
    )

    guard case .confirmation(let content) = presentation.toActionUiModel(transactionId: "1", action: .requestDataDeletion).content else {
      return XCTFail("Expected the confirmation layout for a deletion request.")
    }
    XCTAssertNil(content.contact)
    XCTAssertNil(content.notice)
    XCTAssertEqual(content.intro, .transactionDetailsActionUnavailable)
    XCTAssertEqual(content.buttonTitle, .continueButton)
  }

  func testWithMailContent_WhenMailto_ThenSubjectAndBodyAreEncoded() {
    let url = URL(string: "mailto:support@verifier.example")!.withMailContent(subject: "Request — A+B", body: "Line 1\nLine 2")

    XCTAssertEqual(url.scheme, "mailto")
    XCTAssertTrue(url.absoluteString.hasPrefix("mailto:support@verifier.example?subject="))
    XCTAssertTrue(url.absoluteString.contains("A%2BB"))
    XCTAssertTrue(url.absoluteString.contains("Line%201%0ALine%202"))
    XCTAssertEqual(URL(string: "https://dpa.example")!.withMailContent(subject: "s", body: "b"), URL(string: "https://dpa.example"))
  }

  func testToUiModel_WhenPresentationHasRegistration_ThenRelyingPartyAndAuthoritySectionsAreFilled() {
    let log = TransactionLogDomain.presentation(
      .init(
        id: "1", time: time, result: .completed,
        party: .init(name: "Verifier", identifier: .init(schemeUri: "scheme", value: "123"), contacts: ["support@verifier.example", "+30 210 1234567"]),
        intermediary: .init(name: "Broker", identifier: nil, contacts: []),
        registration: .init(registrarUrl: "https://registry.example", purpose: "Age check", privacyPolicyUrls: ["https://verifier.example/privacy"], dpa: .init(name: "DPA", country: "GR", contacts: ["dpa@example.org"])),
        claimsRequested: [.init(credential: .init(identifier: .mDocPid), claims: [])],
        claimsPresented: []
      )
    )

    let ui = log.toUiModel()

    XCTAssertEqual(ui.sections.map(\.id), ["requested", "shared"])
    let groups = ui.transactionDetailsCardData.details
    XCTAssertEqual(
      groups.map { $0.map(\.id) },
      [
        ["party:purpose", "party:privacy:0", "authority:name", "authority:country", "authority:contact:0"],
        ["party:scheme", "party:contact:0", "party:contact:1"],
        ["party:registrar"],
        ["intermediary:name"]
      ]
    )
    XCTAssertEqual(ui.transactionDetailsCardData.partySubtitles, [.custom("123")])
    XCTAssertEqual(groups[0][2].listItem.overlineText, .transactionDetailsAuthorityLabel)
    XCTAssertNil(groups[0][3].listItem.overlineText)
    XCTAssertEqual(groups[1][1].url, URL(string: "mailto:support@verifier.example"))
    XCTAssertEqual(groups[1][2].url, URL(string: "tel:+302101234567"))
    XCTAssertEqual(groups[2][0].url, URL(string: "https://registry.example"))
    XCTAssertEqual(groups[2][0].listItem.mainTextColor, Theme.shared.color.accent)
    XCTAssertEqual(ui.sections[0].groups.first?.listItems.first?.title, LocalizableStringKey.transactionDetailsNoClaims.toString)
    XCTAssertTrue(ui.sections[1].isEmpty)
  }
}
