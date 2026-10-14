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
import logic_resources

public typealias AppRouteKey = String

public protocol ConfigUiLogic: Sendable {

  var dashboardRoute: AppRoute { get }

  var issuanceRoute: AppRoute { get }

  var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] { get }

  /// The screens of an issuance, presentation or signing in progress, by `AppRoute.info.key`. On them the
  /// session lock waits `AuthenticationConfig.protectedFlowLockTimeout` in the background instead of
  /// `backgroundLockTimeout`, as the Android wallet's `protectedFlowScreens` do.
  var protectedFlowRouteKeys: [AppRouteKey] { get }

  /// The screens a locked wallet may show, by `AppRoute.info.key`: start-up and its login, PIN creation and
  /// the Trust Mark introduction, as the Android wallet's `loginScreens`. While locked, the navigation
  /// opens no other screen, and one already on the path sends the wallet back to start-up.
  var loginRouteKeys: [AppRouteKey] { get }

  init(themeConfiguration: ThemeConfiguration)
}

public extension ConfigUiLogic {
  /// True when `route` is one of the `protectedFlowRouteKeys`.
  func isProtectedFlow(_ route: AppRoute?) -> Bool {
    guard let key = route?.info.key else { return false }
    return protectedFlowRouteKeys.contains(key)
  }

  /// True when `route` is one of the `loginRouteKeys`.
  func isLoginRoute(_ route: AppRoute) -> Bool {
    loginRouteKeys.contains(route.info.key)
  }
}

struct ConfigUiLogicImpl: ConfigUiLogic {

  public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] = [
    AppRoute.featureDashboardModule(.dashboard).info.key: .init(Theme.shared.color.background),
    AppRoute.featureDashboardModule(.documentDetails(id: "")).info.key: .init(Theme.shared.color.background)
  ]

  public var loginRouteKeys: [AppRouteKey] = [
    AppRoute.featureStartupModule(.startup).info.key,
    AppRoute.featureCommonModule(.biometry(config: NoConfig())).info.key,
    AppRoute.featureCommonModule(.quickPin(config: NoConfig())).info.key,
    AppRoute.featureCommonModule(.trustMark(config: NoConfig())).info.key
  ]

  /// The presentation and proximity routes carry a session coordinator, so their keys are written out;
  /// `TestConfigUiLogic` checks them against `AppRoute.info.key`.
  public var protectedFlowRouteKeys: [AppRouteKey] = [
    AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig())).info.key,
    AppRoute.featureIssuanceModule(.credentialOfferRequest(config: NoConfig())).info.key,
    AppRoute.featureIssuanceModule(.issuanceCode(config: NoConfig())).info.key,
    "PresentationRequest",
    "PresentationLoader",
    "ProximityConnection",
    "ProximityRequest",
    "ProximityLoader",
    AppRoute.featureDashboardModule(.signDocument).info.key,
    AppRoute.featureCommonModule(.biometry(config: NoConfig())).info.key
  ]

  public var dashboardRoute: AppRoute {
    return .featureDashboardModule(.dashboard)
  }

  public var issuanceRoute: AppRoute {
    return .featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))
  }

  public init(themeConfiguration: ThemeConfiguration) {
    Theme.config(themeConfiguration: themeConfiguration)
  }
}
