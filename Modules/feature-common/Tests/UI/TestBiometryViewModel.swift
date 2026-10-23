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
@testable import feature_common
@testable import feature_test
@testable import logic_test

final class TestBiometryViewModel: EudiTest {

  private var router: MockRouterHost!
  private var interactor: MockBiometryInteractor!

  override func setUp() {
    super.setUp()
    router = MockRouterHost()
    interactor = MockBiometryInteractor()
    stub(interactor) { mock in
      when(mock.isPinValid(with: any())).thenReturn(.success)
      when(mock.authenticate()).thenReturn(.authenticated)
      when(mock.resetPinThrottle()).thenDoNothing()
    }
  }

  override func tearDown() {
    router = nil
    interactor = nil
    super.tearDown()
  }

  @MainActor
  func testPinEntry_WhenLoginSucceeds_ThenUnlocksTheSessionBeforeTheWalletOpens() async {
    let order = expectUnlockBeforeNavigation()
    let viewModel = makeViewModel(isPreAuthorization: true)

    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [order], timeout: 2)
    verify(interactor).unlockSession()
  }

  @MainActor
  func testOnBiometry_WhenLoginSucceeds_ThenUnlocksTheSessionBeforeTheWalletOpens() async {
    let order = expectUnlockBeforeNavigation()
    let viewModel = makeViewModel(isPreAuthorization: true)

    viewModel.onBiometry()

    await fulfillment(of: [order], timeout: 2)
    verify(interactor).unlockSession()
  }

  @MainActor
  func testPinEntry_WhenAPresentationIsConfirmed_ThenDoesNotUnlockTheSession() async {
    let continued = expectation(description: "presentation continued")
    stub(interactor) { mock in
      when(mock.unlockSession()).thenDoNothing()
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in continued.fulfill() }
    }
    let viewModel = makeViewModel(isPreAuthorization: false)

    viewModel.uiPinInputField = "135792"

    await fulfillment(of: [continued], timeout: 2)
    verify(interactor, never()).unlockSession()
  }
}

private extension TestBiometryViewModel {

  func expectUnlockBeforeNavigation() -> XCTestExpectation {
    let opened = expectation(description: "wallet opened after the unlock")
    let unlocked = RecordingFlag()
    stub(interactor) { mock in
      when(mock.unlockSession()).then { unlocked.set() }
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        if unlocked.isSet { opened.fulfill() }
      }
    }
    return opened
  }

  @MainActor
  func makeViewModel(isPreAuthorization: Bool) -> BiometryViewModel<MockRouterHost> {
    BiometryViewModel(
      router: router,
      interactor: interactor,
      config: UIConfig.Biometry(
        navigationTitle: .enterYourPin,
        caption: .loginCaption,
        quickPinOnlyCaption: .loginCaptionQuickPinOnly,
        navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
        navigationBackType: nil,
        isPreAuthorization: isPreAuthorization,
        shouldInitializeBiometricOnCreate: false
      ),
      throttlePinInput: false
    )
  }
}
