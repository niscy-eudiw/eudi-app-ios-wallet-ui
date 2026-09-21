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
import logic_ui
import logic_core
import logic_business
import logic_resources

public struct TransactionDetailsUiModel: Equatable, Identifiable, Sendable {

  public let id: String
  public let screenTitle: LocalizableStringKey
  public let transactionDetailsCardData: TransactionDetailsCardData
  public let sections: [TransactionDetailsSectionUi]
  public let presentationActions: TransactionPresentationActionsUi?

  public var showsPresentationActions: Bool {
    presentationActions != nil
  }
}

public struct TransactionDetailsSectionUi: Equatable, Identifiable, Sendable {
  public let id: String
  public let title: LocalizableStringKey
  public let fields: [TransactionDetailsFieldUi]
  public let groups: [GenericListItemSection]
  public let emptyText: LocalizableStringKey

  public var isEmpty: Bool {
    fields.isEmpty && groups.isEmpty
  }
}

public struct TransactionDetailsFieldUi: Equatable, Identifiable, Sendable {
  public let id: String
  public let listItem: ListItemData
  public let url: URL?
}

extension TransactionDetailsUiModel {
  static func mock() -> TransactionDetailsUiModel {
    TransactionDetailsUiModel(
      id: "id",
      screenTitle: .transactionInformation,
      transactionDetailsCardData: TransactionDetailsCardData.mock(),
      sections: [
        .init(
          id: "requested",
          title: .transactionDetailsDataRequested,
          fields: [],
          groups: [.init(id: "pid", title: "PID", listItems: [])],
          emptyText: .transactionDetailsNoDataRequested
        )
      ],
      presentationActions: .init(deletionContacts: [], reportContacts: [], dataDeletionRequests: 0, dpaReports: 0)
    )
  }
}

private struct CardParty {
  let label: LocalizableStringKey
  let subtitles: [String]
  let details: [[TransactionDetailsFieldUi]]
}

extension TransactionLogDomain {
  func toUiModel(actions: [TransactionLogDomain] = []) -> TransactionDetailsUiModel {
    .init(
      id: id,
      screenTitle: transactionType.detailsTitle,
      transactionDetailsCardData: toCardData(),
      sections: toSections(),
      presentationActions: {
        guard case .presentation(let presentation) = self else { return nil }
        return .init(
          deletionContacts: presentation.contacts(for: .requestDataDeletion),
          reportContacts: presentation.contacts(for: .reportSuspiciousTransaction),
          dataDeletionRequests: actions.filter { if case .dataDeletionRequest = $0 { true } else { false } }.count,
          dpaReports: actions.filter { if case .dpaReport = $0 { true } else { false } }.count
        )
      }()
    )
  }

  private func toCardData() -> TransactionDetailsCardData {
    let status = transactionStatus
    let reason: String? = if case .notCompleted(let reason) = result { reason } else { nil }
    let party = cardParty
    return .init(
      transactionTypeLabel: transactionType.typeTitle,
      transactionStatusLabel: status.statusTitle,
      transactionIsCompleted: status == .completed,
      transactionDate: .custom(time.formattedTimestamp().toString),
      partyLabel: party.label,
      partyName: partyName.map { .custom($0) },
      partySubtitles: party.subtitles.map { .custom($0) },
      nonCompletionReason: reason?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        ? .custom(reason!)
        : nil,
      details: party.details
    )
  }

  private var cardParty: CardParty {
    switch self {
    case .presentation(let log):
      let registration = TransactionDetailsFieldUi.registrationFields(log.registration)
        + TransactionDetailsFieldUi.authorityFields(log.registration?.dpa)
      let contacts = TransactionDetailsFieldUi.partyFields(log.party, prefix: "party", includeIdentity: false)
      let registrar: [TransactionDetailsFieldUi] = log.registration?.registrarUrl.map {
        [.field(id: "party:registrar", label: .transactionDetailsRegistrarLabel, value: $0, url: $0.webUrl)]
      } ?? []
      let intermediary = log.intermediary.map {
        TransactionDetailsFieldUi.partyFields($0, prefix: "intermediary", label: .transactionDetailsIntermediaryLabel)
      } ?? []
      let groups = [registration, contacts, registrar, intermediary].filter { !$0.isEmpty }
      return .init(label: .transactionDetailsRelyingPartyLabel, subtitles: log.party.subtitles, details: groups)
    case .credentialIssuance(let log):
      return .init(label: .transactionDetailsIssuerLabel, subtitles: log.details.issuer.subtitles, details: [TransactionDetailsFieldUi.issuerFields(log.details)].filter { !$0.isEmpty })
    case .credentialReissuance(let log):
      return .init(label: .transactionDetailsIssuerLabel, subtitles: log.details.issuer.subtitles, details: [TransactionDetailsFieldUi.issuerFields(log.details)].filter { !$0.isEmpty })
    case .credentialDeletion(let log):
      let fields = TransactionDetailsFieldUi.partyFields(log.issuer, prefix: "issuer", includeIdentity: false)
      return .init(label: .transactionDetailsIssuerLabel, subtitles: log.issuer.subtitles, details: [fields].filter { !$0.isEmpty })
    case .signingSealing(let log):
      var details = TransactionDetailsFieldUi.partyFields(log.service, prefix: "service", includeIdentity: false)
      if let certificate = log.certificateSerialNumber {
        details.append(.field(id: "service:certificate", label: .transactionDetailsCertificateLabel, value: certificate))
      }
      return .init(label: .transactionDetailsSigningServiceLabel, subtitles: log.service.subtitles, details: [details].filter { !$0.isEmpty })
    case .dataDeletionRequest(let log):
      return .init(label: .transactionDetailsRelyingPartyLabel, subtitles: log.party.subtitles, details: [])
    case .dpaReport(let log):
      return .init(label: .transactionDetailsAuthorityLabel, subtitles: [log.dpaCountry].compactMap { $0 }, details: [])
    }
  }

  private func toSections() -> [TransactionDetailsSectionUi] {
    switch self {
    case .presentation(let log):
      return [
        .claims(id: "requested", title: .transactionDetailsDataRequested, claims: log.claimsRequested, emptyText: .transactionDetailsNoDataRequested),
        .claims(id: "shared", title: .transactionDetailsDataShare, claims: log.claimsPresented, emptyText: .transactionDetailsNoDataShared)
      ]
    case .credentialIssuance(let log):
      return TransactionDetailsSectionUi.issuance(log.details, isReissuance: false)
    case .credentialReissuance(let log):
      return TransactionDetailsSectionUi.issuance(log.details, isReissuance: true)
    case .credentialDeletion(let log):
      return [.credentials(id: "credentials", credentials: [log.credential])]
    case .signingSealing(let log):
      return TransactionDetailsSectionUi.signing(log)
    case .dataDeletionRequest(let log):
      return [
        .claims(id: "deletion", title: .transactionDetailsDataDeletionSection, claims: log.claims, emptyText: .transactionDetailsNoDataRequested)
      ]
    case .dpaReport:
      return []
    }
  }
}

private extension InteractingPartyDomain {
  var subtitles: [String] {
    [identifier?.value].compactMap { $0 }
  }
}

extension TransactionDetailsSectionUi {
  static func issuance(_ details: IssuanceDetailsDomain, isReissuance: Bool) -> [TransactionDetailsSectionUi] {
    let trigger: LocalizableStringKey? = switch details.isUserTriggered {
    case true?: .transactionDetailsRequestedByYou
    case false?: isReissuance ? .transactionDetailsRenewedByWallet : .transactionDetailsRequestedByIssuer
    case nil: nil
    }
    return [
      .init(
        id: "issuance",
        title: .transactionDetailsIssuanceSection,
        fields: [
          .field(
            id: "issuance:count",
            label: .transactionDetailsIssuedCountLabel,
            value: LocalizableStringKey.transactionDetailsIssuedCount([String(details.issuedCount), String(details.requestedCount)]).toString
          ),
          trigger.map { .field(id: "issuance:trigger", label: .transactionDetailsTriggerLabel, value: $0.toString) }
        ].compactMap { $0 },
        groups: [],
        emptyText: .transactionDetailsNoInformation
      ),
      .credentials(id: "credentials", credentials: details.credentials)
    ]
  }

  static func credentials(id: String, credentials: [CredentialRefDomain]) -> TransactionDetailsSectionUi {
    .init(
      id: id,
      title: .transactionDetailsCredentialsSection,
      fields: credentials.enumerated().map { index, credential in
        .field(id: "\(id):\(index)", label: nil, value: credential.identifier.rawValue)
      },
      groups: [],
      emptyText: .transactionDetailsNoInformation
    )
  }

  static func claims(
    id: String,
    title: LocalizableStringKey,
    claims: [CredentialClaimsDomain],
    emptyText: LocalizableStringKey
  ) -> TransactionDetailsSectionUi {
    .init(
      id: id,
      title: title,
      fields: [],
      groups: claims.enumerated().map { index, credentialClaims in
        let groupId = "\(id):\(index)"
        let items: [ListItemData] = credentialClaims.claims.isEmpty
          ? [.init(id: "\(groupId):empty", mainContent: .text(.transactionDetailsNoClaims))]
          : credentialClaims.claims.enumerated().map { claimIndex, claim in
            .init(id: "\(groupId):\(claimIndex)", mainContent: .text(claim.identifierPath))
          }
        return .init(
          id: groupId,
          title: credentialClaims.credential.identifier.rawValue,
          listItems: items.map { .single(.init(collapsed: $0, domainModel: nil)) }
        )
      },
      emptyText: emptyText
    )
  }

  static func signing(_ log: TransactionLogDomain.SigningSealing) -> [TransactionDetailsSectionUi] {
    var documentFields: [TransactionDetailsFieldUi] = []
    if let fileName = log.fileName {
      documentFields.append(.field(id: "document:name", label: .transactionDetailsFilenameLabel, value: fileName))
    }
    if let size = log.fileSizeBytes, size >= 0 {
      documentFields.append(
        .field(id: "document:size", label: .transactionDetailsFilesizeLabel, value: LocalizableStringKey.transactionDetailsBytes([String(size)]).toString)
      )
    }
    var sections: [TransactionDetailsSectionUi] = [
      .init(id: "document", title: .transactionDetailsDataSigned, fields: documentFields, groups: [], emptyText: .transactionDetailsNoInformation)
    ]
    if let digest = log.dtbsr, !digest.isEmpty {
      sections.append(
        .init(
          id: "technical",
          title: .transactionDetailsTechnicalSection,
          fields: [],
          groups: [
            .init(
              id: "technical:digest",
              title: LocalizableStringKey.transactionDetailsDigestLabel.toString,
              listItems: [.single(.init(collapsed: .init(id: "technical:digest:value", mainContent: .text(.custom(digest))), domainModel: nil))]
            )
          ],
          emptyText: .transactionDetailsNoInformation
        )
      )
    }
    return sections
  }
}

extension TransactionDetailsFieldUi {

  static func partyFields(
    _ party: InteractingPartyDomain,
    prefix: String,
    label: LocalizableStringKey = .transactionDetailsContactLabel,
    includeIdentity: Bool = true
  ) -> [TransactionDetailsFieldUi] {
    var fields: [TransactionDetailsFieldUi] = []
    if includeIdentity, let name = party.name {
      fields.append(.field(id: "\(prefix):name", label: label, value: name))
    }
    if includeIdentity, let identifier = party.identifier {
      fields.append(.field(id: "\(prefix):identifier", label: .transactionDetailsIdentifierLabel, value: identifier.value))
    }
    if let identifier = party.identifier {
      fields.append(.field(id: "\(prefix):scheme", label: .transactionDetailsIdentifierSchemeLabel, value: identifier.schemeUri))
    }
    for (index, contact) in party.contacts.enumerated() {
      fields.append(.field(id: "\(prefix):contact:\(index)", label: label, value: contact, url: contact.contactUrl))
    }
    return fields
  }

  static func issuerFields(_ details: IssuanceDetailsDomain) -> [TransactionDetailsFieldUi] {
    var fields = partyFields(details.issuer, prefix: "issuer", includeIdentity: false)
    if let issuerType = details.issuerType {
      fields.append(.field(id: "issuer:type", label: .transactionDetailsIssuerTypeLabel, value: issuerType))
    }
    return fields
  }

  static func registrationFields(_ registration: PresentationRegistrationDomain?) -> [TransactionDetailsFieldUi] {
    guard let registration else { return [] }
    var fields: [TransactionDetailsFieldUi] = []
    if let purpose = registration.purpose {
      fields.append(.field(id: "party:purpose", label: .transactionDetailsPurposeLabel, value: purpose))
    }
    for (index, policy) in registration.privacyPolicyUrls.enumerated() {
      fields.append(.field(id: "party:privacy:\(index)", label: .transactionDetailsPrivacyPolicyLabel, value: policy, url: policy.webUrl))
    }
    return fields
  }

  static func authorityFields(_ dpa: DpaContactDomain?) -> [TransactionDetailsFieldUi] {
    guard let dpa else { return [] }
    var fields: [TransactionDetailsFieldUi] = []
    if let name = dpa.name {
      fields.append(.field(id: "authority:name", label: .transactionDetailsAuthorityLabel, value: name))
    }
    if let country = dpa.country {
      fields.append(.field(id: "authority:country", label: fields.isEmpty ? .transactionDetailsAuthorityLabel : nil, value: country))
    }
    for (index, contact) in dpa.contacts.enumerated() {
      fields.append(
        .field(id: "authority:contact:\(index)", label: fields.isEmpty ? .transactionDetailsAuthorityLabel : nil, value: contact, url: contact.contactUrl)
      )
    }
    return fields
  }

  static func field(id: String, label: LocalizableStringKey?, value: String, url: URL? = nil) -> TransactionDetailsFieldUi {
    .init(
      id: id,
      listItem: .init(
        id: id,
        mainContent: .text(.custom(value)),
        overlineText: label,
        mainTextColor: url != nil ? Theme.shared.color.accent : Theme.shared.color.primaryLabel,
        trailingContent: url != nil ? .icon(Theme.shared.image.arrowUpRightSquare) : nil
      ),
      url: url
    )
  }
}

extension ClaimRefDomain {
  var identifierPath: LocalizableStringKey {
    guard !segments.isEmpty else { return .transactionDetailsUnknownClaim }
    let path = segments.map { segment in
      switch segment {
      case .key(let name):
        "[\"\(name.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\"]"
      case .index(let index):
        "[\(index)]"
      case .allElements:
        "[*]"
      }
    }.joined()
    return .custom(path)
  }
}
