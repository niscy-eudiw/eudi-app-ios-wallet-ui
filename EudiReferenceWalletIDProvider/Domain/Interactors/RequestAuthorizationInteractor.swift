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
import IdentityDocumentServicesUI
import DcApi18013AnnexC
import IdentityDocumentServices
import Foundation
import feature_common
import logic_core

protocol RequestAuthorizationInteractor: Sendable {
  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel

  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext
  ) async throws
}

final actor RequestAuthorizationInteractorImpl: RequestAuthorizationInteractor {

  private let dcApiHandler: DcApiHandler
  private let configUiLogic: ConfigUiLogic
  private let prefsController: PrefsController

  private let interactor: WalletKitController = DIGraph.shared.resolver.force(
    WalletKitController.self
  )

  init(
    dcApiHandler: DcApiHandler,
    configUiLogic: ConfigUiLogic,
    prefsController: PrefsController
  ) {
    self.dcApiHandler = dcApiHandler
    self.configUiLogic = configUiLogic
    self.prefsController = prefsController
  }

  /// A request is declined while the user has turned off offering documents to apps and websites, since one may
  /// still arrive through a registration the system has not yet withdrawn.
  /// A request that would include a document with a revocation record (revoked, suspended or unrecognised) is
  /// declined, as the in-app flows refuse one; when the records cannot be read, the request is declined too.
  /// `DcApiHandler` validates no reader certificate chain and returns no trust verdict, so the relying
  /// party is never reported as verified. The authority key identifier is kept for a later lookup. Without
  /// a website origin the requester gets the generic name, not the one in its unvalidated certificate, as
  /// on Android.
  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel {
    guard prefsController.isOfferingDocumentsToApps() else {
      throw WalletCoreError.documentOfferingDisabled
    }
    let (docClaimsModels, _, authorityKeyIdentifier, _) = try await dcApiHandler.validateRequest(context.request)
    let blocked = try await interactor.fetchRevokedDocumentStatuses()
    guard !docClaimsModels.contains(where: { blocked[$0.id] != nil }) else {
      throw WalletCoreError.documentBlocked
    }
    let websiteName = context.requestingWebsiteOrigin?.absoluteString ?? LocalizableStringKey.unknownVerifier.toString
    let userImageClaimKeys = configUiLogic.userImageClaimKeys
    let requestsUserImage = docClaimsModels.contains { document in
      document.docClaims.contains { userImageClaimKeys.contains($0.name) }
    }
    let documents = docClaimsModels.compactMap {
      $0.transformToDocumentUi(isSensitive: false)
    }

    return AuthorizationUIModel(
      issuerName: websiteName,
      documents: documents.map { document in
        return AuthorizationUIDocument(
          id: document.id,
          name: document.documentName,
          requestedElements: document.documentFields
        )
      },
      isRelyingPartyVerified: false,
      requestsUserImage: requestsUserImage,
      authorityKeyIdentifier: authorityKeyIdentifier
    )
  }

  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext
  ) async throws {
    guard prefsController.isOfferingDocumentsToApps() else {
      throw WalletCoreError.documentOfferingDisabled
    }
    try await context.sendResponse { rawRequest in

      try await self.dcApiHandler.validateConsistency(
        request: context.request,
        rawRequest: rawRequest
      )

      let responseData = try await self.dcApiHandler.buildAndEncryptResponse(
        rawRequest: rawRequest,
        originUrl: context.requestingWebsiteOrigin?.absoluteString
      )

      return ISO18013MobileDocumentResponse(responseData: responseData)
    }
  }
}
