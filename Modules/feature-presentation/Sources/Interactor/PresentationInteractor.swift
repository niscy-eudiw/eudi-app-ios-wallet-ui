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
import feature_common

public struct OnlineAuthenticationRequestSuccessModel: Sendable {
  var requestDataCells: [RequestDataUiModel]
  var relyingParty: String
  var dataRequestInfo: String
  var isTrusted: Bool
}

public enum PresentationCoordinatorPartialState: Sendable {
  case success(RemoteSessionCoordinator)
  case failure(Error)
}

public enum RemotePublisherPartialState: Sendable {
  case success(AsyncStream<PresentationState>)
  case failure(Error)
}

public enum RemoteSentResponsePartialState: Sendable {
  case sent
  case failure(Error)
}

public protocol PresentationInteractor: Sendable {
  func getSessionStatePublisher() -> RemotePublisherPartialState
  func getCoordinator() -> PresentationCoordinatorPartialState
  func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>
  func onResponsePrepare(requestItems: [RequestDataUiModel]) async -> Result<RequestItemConvertible, Error>
  func onRequestReceived() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>
  func onSendResponse() async -> RemoteSentResponsePartialState
  func updatePresentationCoordinator(with coordinator: RemoteSessionCoordinator)
  func storeDynamicIssuancePendingUrl(with url: URL)
  func stopPresentation()
}

final class PresentationInteractorImpl: PresentationInteractor {

  private let sessionCoordinatorHolder: SessionCoordinatorHolder
  private let walletKitController: WalletKitController

  init(
    with presentationCoordinator: RemoteSessionCoordinator,
    and walletKitController: WalletKitController,
    also sessionCoordinatorHolder: SessionCoordinatorHolder
  ) {
    self.walletKitController = walletKitController
    self.sessionCoordinatorHolder = sessionCoordinatorHolder
    self.sessionCoordinatorHolder.setActiveRemoteCoordinator(presentationCoordinator)
  }

  public func getSessionStatePublisher() -> RemotePublisherPartialState {
    do {
      return .success(try self.sessionCoordinatorHolder.getActiveRemoteCoordinator().getStream())
    } catch {
      return .failure(error)
    }
  }

  public func getCoordinator() -> PresentationCoordinatorPartialState {
    do {
      return .success(try self.sessionCoordinatorHolder.getActiveRemoteCoordinator())
    } catch {
      return .failure(error)
    }
  }

  public func updatePresentationCoordinator(with coordinator: RemoteSessionCoordinator) {
    self.sessionCoordinatorHolder.setActiveRemoteCoordinator(coordinator)
  }

  public func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error> {
    try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().initialize()
    return await onRequestReceived()
  }

  public func onRequestReceived() async -> Result<OnlineAuthenticationRequestSuccessModel, Error> {
    do {
      let response = try await sessionCoordinatorHolder.getActiveRemoteCoordinator().requestReceived()
      let revokedDocuments = (try? await walletKitController.fetchRevokedDocuments()) ?? []
      let documents = response.items.filter { item in !revokedDocuments.contains(where: { $0 == item.docId }) }
      guard !documents.isEmpty else { return .failure(WalletCoreError.unableFetchDocuments) }
      return .success(
        .init(
          requestDataCells: documents.toUiModels(
            with: self.walletKitController
          ),
          relyingParty: response.relyingParty,
          dataRequestInfo: response.dataRequestInfo,
          isTrusted: response.isTrusted
        )
      )
    } catch {
      return .failure(error)
    }
  }

  public func onResponsePrepare(requestItems: [RequestDataUiModel]) async -> Result<RequestItemConvertible, Error> {

    let requestConvertible = requestItems.prepareRequest()

    guard requestConvertible.items.isEmpty == false else {
      return .failure(PresentationSessionError.conversionToRequestItemModel)
    }

    do {
      try self.sessionCoordinatorHolder.getActiveRemoteCoordinator().setState(presentationState: .responseToSend(requestConvertible))
    } catch {
      return .failure(error)
    }

    return .success(requestConvertible.items)
  }

  public func onSendResponse() async -> RemoteSentResponsePartialState {

    guard
      let state = try? await sessionCoordinatorHolder.getActiveRemoteCoordinator().getState(),
      case PresentationState.responseToSend(let responseItem) = state
    else {
      return .failure(PresentationSessionError.invalidState)
    }

    do {
      try await self.sessionCoordinatorHolder.getActiveRemoteCoordinator().sendResponse(response: responseItem)
      return .sent
    } catch {
      return .failure(error)
    }
  }

  public func storeDynamicIssuancePendingUrl(with url: URL) {
    walletKitController.storeDynamicIssuancePendingUrl(with: url)
  }

  public func stopPresentation() {
    walletKitController.stopPresentation()
    try? sessionCoordinatorHolder.getActiveRemoteCoordinator().stopPresentation()
  }
}
