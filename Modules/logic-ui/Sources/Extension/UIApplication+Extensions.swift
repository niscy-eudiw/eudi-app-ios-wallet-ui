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
import UIKit

public extension UIApplication {
  var currentUIWindow: UIWindow? {
    return self
      .connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }
  }
  /// True while the RQES SDK's screens are presented over the wallet's own, for the session lock
  /// (`SessionController.setCovered(_:)`). The issuer's sign-in is marked by the issuance interactors
  /// instead, since it is not presented from the wallet's window.
  var isWalletCoveredByAnotherScreen: Bool {
    Self.isCovered(presentedFrom: currentUIWindow?.rootViewController)
  }

  /// True when a controller presented from `root`, at any depth, is a type of one of `modules`.
  static func isCovered(
    presentedFrom root: UIViewController?,
    byModules modules: [String] = ["EudiRQESUi"]
  ) -> Bool {
    var presented = root?.presentedViewController
    while let controller = presented {
      let typeName = String(reflecting: type(of: controller))
      if modules.contains(where: { typeName.hasPrefix($0 + ".") }) {
        return true
      }
      presented = controller.presentedViewController
    }
    return false
  }
  func hideKeyboard() {
    self.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
  func openAppSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    self.open(url, options: [:])
  }
}
