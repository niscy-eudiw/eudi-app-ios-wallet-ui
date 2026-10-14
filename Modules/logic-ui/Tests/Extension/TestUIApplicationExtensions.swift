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
import UIKit
@testable import logic_ui
@testable import logic_test

final class TestUIApplicationExtensions: EudiTest {

  @MainActor
  func testIsCovered_WhenAControllerOfACoveringModuleIsPresented_ThenIsTrue() {
    let root = PresentingController(presenting: PresentingController(presenting: nil))

    XCTAssertTrue(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests"]))
  }

  @MainActor
  func testIsCovered_WhenTheCoveringControllerIsPresentedOverAnother_ThenIsTrue() {
    let covering = CoveringScreens.Controller(presenting: nil)
    let root = PresentingController(presenting: PresentingController(presenting: covering))

    XCTAssertTrue(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests.CoveringScreens"]))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests.OtherScreens"]))
  }

  @MainActor
  func testIsCovered_WhenNothingIsPresentedOrOnlyOtherModules_ThenIsFalse() {
    let root = PresentingController(presenting: UIViewController())

    XCTAssertFalse(UIApplication.isCovered(presentedFrom: root))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: PresentingController(presenting: nil)))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: nil))
  }
}

/// Stands for a covering SDK: its type names start with `logic_ui_tests.CoveringScreens.`.
enum CoveringScreens {
  final class Controller: PresentingController {}
}

class PresentingController: UIViewController {
  private let presented: UIViewController?

  init(presenting presented: UIViewController?) {
    self.presented = presented
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    nil
  }

  override var presentedViewController: UIViewController? {
    presented
  }
}
