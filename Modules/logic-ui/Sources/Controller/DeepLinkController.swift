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

public struct DeepLink {}

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
  private let openURL: @Sendable @MainActor (URL) -> Void
  private let pendingLink = OSAllocatedUnfairLock<URL?>(initialState: nil)

  /// Removes a link an earlier build kept in `UserDefaults`, so that it does not outlive its process.
  /// `openURL` opens a link of no wallet type once `URL.openInBrowser(using:)` has accepted it as an `https`
  /// link; the default is the system's opener.
  init(
    prefsController: PrefsController,
    urlSchemaController: UrlSchemaController,
    walletKitController: WalletKitController,
    openURL: @escaping @Sendable @MainActor (URL) -> Void = { UIApplication.shared.open($0) }
  ) {
    self.urlSchemaController = urlSchemaController
    self.walletKitController = walletKitController
    self.openURL = openURL
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
        let opensAWalletFlow = deepLinkExecutable.action != .external
        return opensAWalletFlow && !routerHost.isScreenForeground(with: dashboard) ? dashboard : nil
      }
      return isVciExecutable && !routerHost.isScreenForeground(with: addDocument) ? addDocument : nil
    }

    let returnScreen = screenToReturnTo

    guard
      returnScreen == nil && (routerHost.userIsLoggedInWithDocuments() || isVciExecutable)
    else {
      if deepLinkExecutable.action != .external, let url = deepLinkExecutable.link.url {
        cacheDeepLinkURL(url: url)
      }
      if let returnScreen {
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
    case .external:
      deepLinkExecutable.plainUrl.openInBrowser(using: openURL)
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

public extension DeepLink {
  struct Executable: Equatable, Sendable {

    public let link: URLComponents
    public let plainUrl: URL
    public let action: DeepLink.Action
  }
}

public extension DeepLink {
  enum Action: String, Equatable, Sendable {

    case openid4vp
    case credential_offer
    case haip_vci
    case haip_vp
    case rqes
    case external

    private var name: String {
      return rawValue.replacingOccurrences(of: "_", with: "-")
    }

    private func getSchemas(
      with urlSchemaController: UrlSchemaController
    ) -> [String] {
      return urlSchemaController.retrieveSchemas(with: name)
    }

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vci.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      case _ where rqes.getSchemas(with: urlSchemaController).contains(scheme):
        return .rqes
      default:
        return .external
      }
    }
  }
}
