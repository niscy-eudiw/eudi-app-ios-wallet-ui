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
import logic_core
import logic_resources
import logic_business
import logic_ui

public struct DocumentTabUIModel: Identifiable, Equatable, FilterableItemPayload {

  @EquatableNoop
  public var id: String

  public let value: Value
  public let listItem: ListItemData
}

public extension DocumentTabUIModel {

  struct Value: Equatable, Sendable {

    public struct RemoteImage: Equatable, Sendable {
      public static func == (lhs: RemoteImage, rhs: RemoteImage) -> Bool {
        return lhs.url == rhs.url
      }
      public let url: URL?
      public let placeholder: Image?
    }

    @EquatableNoop
    public var id: String

    public let heading: String
    public let title: String
    public let createdAt: Date
    public let expiresAt: String?
    public let hasExpired: Bool
    public let state: State
    public let image: RemoteImage?
    public let documentCategory: DocumentCategory
  }
}

public extension DocumentTabUIModel.Value {
  enum State: Equatable, Sendable {
    case issued
    case pending
    case failed
    case revoked
  }
}

extension DocClaimsDecodable {
  func transformToDocumentTabUi(
    with failedDocuments: [String] = [],
    categories: DocumentCategories,
    isRevoked: Bool,
    documentIsLowOnCredentials: Bool = false,
    usageCount: (remaining: Int?, total: Int?)? = nil
  ) -> DocumentTabUIModel {
    let state: DocumentTabUIModel.Value.State = failedDocuments.contains(where: { $0 == self.id })
    ? .failed
    : (self is DeferrredDocument)
    ? .pending
    : isRevoked
    ? .revoked
    : .issued

    let expiresAt = self.getExpiryDate(
      parser: {
        Locale.current.localizedDateTime(
          date: $0,
          uiFormatter: "dd MMM yyyy"
        )
      }
    )
    return .init(
      id: UUID().uuidString,
      value: .init(
        id: self.id,
        heading: self.issuerName,
        title: self.displayName.orEmpty,
        createdAt: self.createdAt,
        expiresAt: expiresAt,
        hasExpired: self.hasExpired,
        state: state,
        image: .init(
          url: self.issuerLogo,
          placeholder: Theme.shared.image.id
        ),
        documentCategory: categories.first(where: { $1.contains(self.documentTypeIdentifier) })?.key ?? .Other
      ),
      listItem: .init(
        mainText: .custom(displayName.orEmpty),
        overlineText: .custom(issuerName),
        supportingText: supportingText(state, expiresAt),
        supportingTextColor: supportingColor(state),
        leadingIcon: .init(
          imageUrl: issuerLogo,
          image: Theme.shared.image.id
        ),
        trailingContent: .textWithIcon(
          indicatorImage(state, documentIsLowOnCredentials: documentIsLowOnCredentials),
          indicatorImageColor(state, documentIsLowOnCredentials: documentIsLowOnCredentials),
          getUsageCount(usage: usageCount)
        )
      )
    )
  }

  func supportingText(
    _ state: DocumentTabUIModel.Value.State,
    _ expiresAt: String?
  ) -> LocalizableStringKey? {
    if hasExpired {
      return .expired
    } else {
      switch state {
      case .issued:
        guard let expiresAt = expiry(expiresAt: expiresAt) else { return nil }
        return .custom(expiresAt)
      case .pending:
        return .pending
      case .failed:
        return .issuanceFailed
      case .revoked:
        return .revoked
      }
    }
  }

  func expiry(expiresAt: String?) -> String? {
    guard let expires = expiresAt else {
      return nil
    }
    return LocalizableStringKey.validUntil([expires]).toString.replacingOccurrences(of: "\n", with: "")
  }

  func supportingColor(
    _ state: DocumentTabUIModel.Value.State
  ) -> Color {
    if hasExpired {
      return Theme.shared.color.error
    }

    switch state {
    case .issued:
      return Theme.shared.color.onSurfaceVariant
    case .pending:
      return Theme.shared.color.warning
    case .failed, .revoked:
      return Theme.shared.color.error
    }
  }

  func indicatorImageColor(
    _ state: DocumentTabUIModel.Value.State,
    documentIsLowOnCredentials: Bool
  ) -> Color {
    if hasExpired {
      return Theme.shared.color.error
    }

    if documentIsLowOnCredentials {
      return Theme.shared.color.warning
    }

    switch state {
    case .issued:
      return Theme.shared.color.onSurfaceVariant
    case .pending:
      return Theme.shared.color.warning
    case .failed, .revoked:
      return Theme.shared.color.error
    }
  }

  func indicatorImage(
    _ state: DocumentTabUIModel.Value.State,
    documentIsLowOnCredentials: Bool
  ) -> Image {
    if hasExpired {
      return Theme.shared.image.errorIndicator
    }

    if documentIsLowOnCredentials {
      return Theme.shared.image.errorIndicator
    }

    switch state {
    case .issued:
      return Theme.shared.image.chevronRight
    case .pending:
      return Theme.shared.image.clockIndicator
    case .failed, .revoked:
      return Theme.shared.image.errorIndicator
    }
  }

  func getUsageCount(usage: (remaining: Int?, total: Int?)? = nil) -> LocalizableStringKey {
    if let remaining = usage?.remaining?.string,
       let total = usage?.total?.string {
      .documentsListCredentialsUsageText([remaining, total])
    } else {
      .custom("")
    }
  }
}
