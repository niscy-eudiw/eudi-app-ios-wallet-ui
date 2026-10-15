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
import logic_business
@testable import feature_common
@testable import feature_test
@testable import logic_test

final class TestQuickPinViewModel: EudiTest {

  private var router: MockRouterHost!
  private var interactor: MockQuickPinInteractor!

  override func setUp() {
    super.setUp()
    router = MockRouterHost()
    interactor = MockQuickPinInteractor()
  }

  override func tearDown() {
    router = nil
    interactor = nil
    super.tearDown()
  }

  @MainActor
  func testPinCreation_WhenThePinIsSet_ThenUnlocksTheSessionBeforeTheSuccessScreen() async throws {
    let unlocked = RecordingFlag()
    let shown = expectation(description: "success screen after the unlock")
    stub(interactor) { mock in
      when(mock.setPin(newPin: any())).thenReturn(.success)
      when(mock.unlockSession()).then { unlocked.set() }
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in
        if unlocked.isSet { shown.fulfill() }
      }
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)

    try await enterTwice("135792", in: viewModel)

    await fulfillment(of: [shown], timeout: 3)
  }

  @MainActor
  func testPinCreation_WhenSettingThePinFails_ThenDoesNotUnlock() async throws {
    stub(interactor) { mock in
      when(mock.setPin(newPin: any())).thenReturn(.failure(RuntimeError.genericError))
    }
    let viewModel = makeViewModel(flow: .setWithoutActivation)

    try await enterTwice("135792", in: viewModel)
    try await Task.sleep(seconds: 0.6)

    verify(interactor).setPin(newPin: any())
    verify(interactor, never()).unlockSession()
    verify(router, never()).push(with: any())
  }

  @MainActor
  func testPinChange_WhenTheNewPinIsSet_ThenDoesNotUnlock() async throws {
    let shown = expectation(description: "success screen")
    stub(interactor) { mock in
      when(mock.isPinValid(pin: any())).thenReturn(.success)
      when(mock.resetPinThrottle()).thenDoNothing()
      when(mock.setPin(newPin: any())).thenReturn(.success)
    }
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in shown.fulfill() }
    }
    let viewModel = makeViewModel(flow: .update)

    try await enter("135792", in: viewModel)
    try await enterTwice("246813", in: viewModel)

    await fulfillment(of: [shown], timeout: 3)
    verify(interactor, never()).unlockSession()
  }
}

private extension TestQuickPinViewModel {

  @MainActor
  func enterTwice(_ pin: String, in viewModel: QuickPinViewModel<MockRouterHost>) async throws {
    try await enter(pin, in: viewModel)
    try await enter(pin, in: viewModel)
  }

  /// Waits past two 250 ms debounce windows: the entry's, and the one for the empty field the view model
  /// sets after it, so that the same PIN entered again is not dropped as a duplicate.
  @MainActor
  func enter(_ pin: String, in viewModel: QuickPinViewModel<MockRouterHost>) async throws {
    viewModel.uiPinInputField = pin
    try await Task.sleep(seconds: 0.8)
  }

  @MainActor
  func makeViewModel(flow: QuickPinUiConfig.Flow) -> QuickPinViewModel<MockRouterHost> {
    QuickPinViewModel(router: router, interactor: interactor, config: QuickPinUiConfig(flow: flow))
  }
}
