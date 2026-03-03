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
import logic_business
import logic_core
import EudiRQESUi

public protocol ScannerInteractor: FormValidatorInteractor, Sendable {
  func startCrossDevicePresentation(scanResult: String) async -> RemoteSessionCoordinator
  func initiateSigning(url: URL) async
}

final actor ScannerInteractorImpl: ScannerInteractor {

  private let formValidator: FormValidator
  private let walletKitController: WalletKitController
  private let configLogic: ConfigLogic

  init(
    formValidator: FormValidator,
    walletKitController: WalletKitController,
    configLogic: ConfigLogic
  ) {
    self.formValidator = formValidator
    self.walletKitController = walletKitController
    self.configLogic = configLogic
  }

  func validateForm(form: ValidatableForm) async -> FormValidationResult {
    return await formValidator.validateForm(form: form)
  }

  func validateForms(forms: [ValidatableForm]) async -> FormsValidationResult {
    return await formValidator.validateForms(forms: forms)
  }

  func startCrossDevicePresentation(scanResult: String) async -> RemoteSessionCoordinator {
    return await walletKitController.startCrossDevicePresentation(
      urlString: scanResult
    )
  }

  func initiateSigning(url: URL) async {

    let eudiRQESUi: EudiRQESUi

    do {
      eudiRQESUi = try .instance()
    } catch {
      eudiRQESUi = await .init(config: configLogic.rqesConfig)
    }

    guard let controller = await UIApplication.shared.topViewController() else {
      return
    }

    try? await eudiRQESUi.initiate(
      on: controller,
      fileUrl: url
    )
  }
}
