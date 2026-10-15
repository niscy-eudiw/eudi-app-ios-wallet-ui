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
import os
import logic_business
import logic_core
import EudiRQESUi

public protocol DeepLinkController: Sendable {
  func hasDeepLink(url: URL) -> DeepLink.Executable?
  /// Opens the link, or keeps it for later. A presentation link starts its session only when its request
  /// screen opens. While the wallet is logged in, a presentation, signing or credential-offer link that
  /// arrives away from the dashboard ends the flow on screen: the wallet returns to the dashboard, which
  /// opens the link. A wallet without documents returns to the add-document screen for an offer.
  @MainActor func handleDeepLinkAction(
    routerHost: RouterHost,
    deepLinkExecutable: DeepLink.Executable
  )
  /// The link kept for after login, or for the screen it waits for. It lives for this process only.
  func getPendingDeepLinkAction() -> DeepLink.Executable?
  func cacheDeepLinkURL(url: URL)
  func removeCachedDeepLinkURL()
}

final class DeepLinkControllerImpl: DeepLinkController {

  private let urlSchemaController: UrlSchemaController
  private let walletKitController: WalletKitController
  private let pendingLink = OSAllocatedUnfairLock<URL?>(initialState: nil)

  /// Removes a link an earlier build kept in `UserDefaults`, so that it does not outlive its process.
  init(
    prefsController: PrefsController,
    urlSchemaController: UrlSchemaController,
    walletKitController: WalletKitController
  ) {
    self.urlSchemaController = urlSchemaController
    self.walletKitController = walletKitController
    prefsController.remove(forKey: .cachedDeepLink)
  }

  public func getPendingDeepLinkAction() -> DeepLink.Executable? {
    pendingLink.withLock { $0 }.flatMap(hasDeepLink(url:))
  }

  public func hasDeepLink(url: URL) -> DeepLink.Executable? {
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
       let scheme = components.scheme,
       let action = DeepLink.Action.parseType(with: scheme, and: urlSchemaController) {
      return DeepLink.Executable(link: components, plainUrl: url, action: action)
    }
    return nil
  }

  public func handleDeepLinkAction(
    routerHost: RouterHost,
    deepLinkExecutable: DeepLink.Executable
  ) {

    var isVciExecutable: Bool {
      deepLinkExecutable.action == .credential_offer && routerHost.userIsLoggedInWithNoDocuments()
    }

    var screenToReturnTo: AppRoute? {
      let dashboard = AppRoute.featureDashboardModule(.dashboard)
      let addDocument = AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))
      if routerHost.userIsLoggedInWithDocuments() {
        return !routerHost.isScreenForeground(with: dashboard) ? dashboard : nil
      }
      return isVciExecutable && !routerHost.isScreenForeground(with: addDocument) ? addDocument : nil
    }

    let returnScreen = screenToReturnTo

    guard
      returnScreen == nil && (routerHost.userIsLoggedInWithDocuments() || isVciExecutable)
    else {
      if let url = deepLinkExecutable.link.url {
        cacheDeepLinkURL(url: url)
      }
      if let returnScreen {
        Task { [walletKitController] in await walletKitController.stopPresentation() }
        routerHost.popTo(
          with: returnScreen,
          inclusive: false
        )
      }
      return
    }

    removeCachedDeepLinkURL()

    switch deepLinkExecutable.action {
    case .openid4vp, .haip_vp:
      Task { @MainActor in
        let remoteSessionCoordinator = await walletKitController.startSameDevicePresentation(
          deepLink: deepLinkExecutable.link
        )
        routerHost.push(
          with: .featurePresentationModule(
            .presentationRequest(
              presentationCoordinator: remoteSessionCoordinator,
              originator: .featureDashboardModule(.dashboard)
            )
          )
        )
      }
    case .credential_offer, .haip_vci:
      let config = UIConfig.Generic(
        arguments: ["uri": deepLinkExecutable.plainUrl.absoluteString],
        navigationSuccessType: routerHost.userIsLoggedInWithDocuments()
        ? .popTo(.featureDashboardModule(.dashboard))
        : .push(.featureDashboardModule(.dashboard)),
        navigationCancelType: .pop
      )
      routerHost.push(with: .featureIssuanceModule(.credentialOfferRequest(config: config)))
    case .rqes:

      guard let code = deepLinkExecutable.link.queryItems?.first(where: { $0.name == "code" })?.value else {
        return
      }

      Task { @MainActor in

        while UIApplication.shared.topViewController() == nil {
          try? await Task.sleep(for: .milliseconds(100))
        }

        guard let controller = UIApplication.shared.topViewController() else {
          return
        }

        try? await EudiRQESUi.instance().resume(
          on: controller,
          authorizationCode: code
        )
      }
    }
  }

  public func cacheDeepLinkURL(url: URL) {
    pendingLink.withLock { $0 = url }
  }

  public func removeCachedDeepLinkURL() {
    pendingLink.withLock { $0 = nil }
  }
}
