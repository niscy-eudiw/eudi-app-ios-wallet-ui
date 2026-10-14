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
import logic_business
import feature_common

public enum ProximityDeviceEngagementPartialState: Sendable {
  case success
  case failure(Error)
}

public enum ProximityResponsePartialState: Sendable {
  case sent
  case failure(Error)
}

public enum ProximityResponsePreparationPartialState: Sendable {
  case success(RequestItemConvertible)
  case failure(Error)
}

public enum ProximityRequestPartialState: Sendable {
  case success(
    [RequestDataUiModel],
    relyingParty: String,
    dataRequestInfo: String,
    isTrusted: Bool,
    relyingPartyRegistration: RelyingPartyRegistration
  )
  case notSecuredRequest
  case failure(Error)
}

public enum ProximityQrCodePartialState: Sendable {
  case success(UIImage)
  case failure(Error)
}

public enum ProximityPublisherPartialState: Sendable {
  case success(AsyncStream<PresentationState>)
  case failure(Error)
}

public enum ProximityCoordinatorPartialState: Sendable {
  case success(ProximitySessionCoordinator)
  case failure(Error)
}

public protocol ProximityInteractor: Sendable {

  func getSessionStatePublisher() async -> ProximityPublisherPartialState
  func getCoordinator() async -> ProximityCoordinatorPartialState

  func onDeviceEngagement() async -> ProximityDeviceEngagementPartialState
  func onQRGeneration() async -> ProximityQrCodePartialState
  func onRequestReceived() async -> ProximityRequestPartialState
  func onResponsePrepare(requestItems: [RequestDataUiModel]) async -> ProximityResponsePreparationPartialState
  func onSendResponse() async -> ProximityResponsePartialState
  func stopPresentation() async
  func registrationForFailedRequest() async -> RelyingPartyRegistration?

}

/// Works on the session its route carries, never on another one started later.
final actor ProximityInteractorImpl: ProximityInteractor {

  private let proximitySessionCoordinator: ProximitySessionCoordinator
  private let walletKitController: WalletKitController

  init(
    with proximitySessionCoordinator: ProximitySessionCoordinator,
    and walletKitController: WalletKitController
  ) {
    self.proximitySessionCoordinator = proximitySessionCoordinator
    self.walletKitController = walletKitController
  }

  func getCoordinator() async -> ProximityCoordinatorPartialState {
    .success(proximitySessionCoordinator)
  }

  public func getSessionStatePublisher() async -> ProximityPublisherPartialState {
    .success(proximitySessionCoordinator.getStream())
  }

  public func onDeviceEngagement() async -> ProximityDeviceEngagementPartialState {
    do {
      try await proximitySessionCoordinator.initialize()
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func onQRGeneration() async -> ProximityQrCodePartialState {
    do {
      let qrImage = try await proximitySessionCoordinator.startQrEngagement()
      return .success(qrImage)
    } catch {
      return .failure(error)
    }

  }

  public func onRequestReceived() async -> ProximityRequestPartialState {
    do {
      let coordinator = proximitySessionCoordinator
      let response = try await coordinator.requestReceived()
      let blockedDocuments = try await walletKitController.fetchRevokedDocumentStatuses()
      let documents = (response.itemSets.first ?? []).filter { item in blockedDocuments[item.docId] == nil }
      let registrationPolicy = coordinator.relyingPartyRegistration
      let overaskedClaims = response.overaskedClaims
      return .success(
        documents.toUiModels(
          with: self.walletKitController,
          overaskedPaths: documents.overaskedPaths(from: overaskedClaims)
        ),
        relyingParty: response.relyingParty,
        dataRequestInfo: response.dataRequestInfo,
        isTrusted: response.isTrusted,
        relyingPartyRegistration: await walletKitController.getVerifierRegistration(
          policy: registrationPolicy,
          trustViolations: coordinator.relyingPartyWarningViolations,
          overaskedClaims: overaskedClaims,
          verifierName: response.relyingParty,
          verifierIsTrusted: response.isTrusted
        )
      )
    } catch {
      return error.isTrustBlocked ? .notSecuredRequest : .failure(error)
    }
  }

  public func onResponsePrepare(requestItems: [RequestDataUiModel]) async -> ProximityResponsePreparationPartialState {

    let requestConvertible = requestItems.prepareRequest()

    guard requestConvertible.items.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    proximitySessionCoordinator.setState(presentationState: .responseToSend(requestConvertible))

    return .success(requestConvertible.items)
  }

  public func onSendResponse() async -> ProximityResponsePartialState {

    guard
      case PresentationState.responseToSend(let responseItem) = await proximitySessionCoordinator.getState()
    else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await proximitySessionCoordinator.sendResponse(response: responseItem)
      return .sent
    } catch {
      return .failure(error)
    }
  }

  public func registrationForFailedRequest() async -> RelyingPartyRegistration? {
    await walletKitController.getVerifierRegistrationForFailedRequest()
  }

  public func stopPresentation() async {
    await walletKitController.stopPresentation()
    proximitySessionCoordinator.stopPresentation()
  }
}
