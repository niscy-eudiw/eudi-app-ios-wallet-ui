/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import logic_ui
import logic_business

struct BiometryState: ViewState {
  let config: UIConfig.Biometry
  let areBiometricsEnabled: Bool
  let pinError: String?
  let throttlePinInput: Bool
  let scenePhase: ScenePhase
  let pendingNavigation: UIConfig.NavigationConfig?
  let autoBiometryInitiated: Bool
  let biometryImage: Image?
}

@MainActor
final class BiometryViewModel<Router: RouterHostType, Interactor: BiometryInteractorType>: BaseViewModel<Router, BiometryState> {

  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250
  private let PIN_INPUT_DEBOUNCE = 250

  @Published var uiPinInputField: String = ""
  @Published var biometryError: SystemBiometricsError?

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor,
    config: any UIConfigType,
    throttlePinInput: Bool = true
  ) {
    guard let config = config as? UIConfig.Biometry else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        areBiometricsEnabled: interactor.isBiometryEnabled(),
        pinError: nil,
        throttlePinInput: throttlePinInput,
        scenePhase: .active,
        pendingNavigation: nil,
        autoBiometryInitiated: false,
        biometryImage: interactor.biometricsImage
      )
    )

    self.subscribeToPinInput()
  }

  func onAppearBiometry() {
    if viewState.config.shouldInitializeBiometricOnCreate, viewState.areBiometricsEnabled, !viewState.autoBiometryInitiated {
      setNewState(autoBiometryInitiated: true)
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(AUTO_VERIFY_ON_APPEAR_DELAY)) {
        self.onBiometry()
      }
    }
  }

  func onPop() {
    doNavigation(config: viewState.config.navigationBackConfig)
  }

  func onBiometry() {
    interactor.authenticate()
      .sink { _ in } receiveValue: { [weak self] (state) in
        guard let self = self else { return }
        switch state {
        case .authenticated:
          self.authenticated()
        case .failure(let error):
          if error != .biometricError {
            self.biometryError = error
          }
        default: break
        }
      }.store(in: &cancellables)
  }

  func onSettings() {
    interactor.openSettingsURL {}
  }

  func setPhase(with phase: ScenePhase) {
    setNewState(scenePhase: phase)
    if let pending = viewState.pendingNavigation {
      doNavigation(config: pending)
    }
  }

  private func subscribeToPinInput() {

    let publisher = self.$uiPinInputField.dropFirst()

    if viewState.throttlePinInput {
      publisher
        .debounce(for: .milliseconds(PIN_INPUT_DEBOUNCE), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    } else {
      publisher
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    }
  }

  private func processPin(value: String) {
    if value.count == 4 {
      switch interactor.isPinValid(with: uiPinInputField) {
      case .success:
        self.authenticated()
      case .failure(let error):
        setNewState(pinError: error.localizedDescription)
      }
    } else {
      setNewState(pinError: nil)
    }
  }

  private func authenticated() {
    doNavigation(config: viewState.config.navigationSuccessConfig)
  }

  private func doNavigation(config: UIConfig.NavigationConfig) {

    guard viewState.scenePhase == .active else {
      setNewState(pendingNavigation: config)
      return
    }

    switch config.navigationType {
    case .pop:
      router.popTo(with: config.screen)
    case .push:
      router.push(with: config.screen)
    }
  }

  private func setNewState(
    pinError: String? = nil,
    scenePhase: ScenePhase? = nil,
    pendingNavigation: UIConfig.NavigationConfig? = nil,
    autoBiometryInitiated: Bool? = nil
  ) {
    setState { previous in
        .init(
          config: previous.config,
          areBiometricsEnabled: previous.areBiometricsEnabled,
          pinError: pinError,
          throttlePinInput: previous.throttlePinInput,
          scenePhase: scenePhase ?? previous.scenePhase,
          pendingNavigation: pendingNavigation ?? previous.pendingNavigation,
          autoBiometryInitiated: autoBiometryInitiated ?? previous.autoBiometryInitiated,
          biometryImage: previous.biometryImage
        )
    }
  }
}