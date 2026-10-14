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
import IdentityDocumentServices
import IdentityDocumentServicesUI
import feature_common
import Observation

@Copyable
struct RequestAuthorizationViewState: ViewState {
  let items: [AuthorizationUIRequestItem]
  let errorMessage: String?
  let isLoading: Bool
  let contentHeaderConfig: ContentHeaderConfig
  /// The warning to acknowledge before Accept: `accessCertificateNotTrusted` while the requester is not
  /// verified, which the reference app never reports it to be.
  let warning: RegistrationWarning?
}

@MainActor
@Observable
final class RequestAuthorizationViewModel: ViewModel<RequestAuthorizationViewState> {
  var showBiometryView: Bool = false
  var isRiskAcknowledged: Bool = false

  private var isRequestAuthorized: Bool = false

  private var context: ISO18013MobileDocumentRequestContext?
  private var interactor: RequestAuthorizationInteractor = DIGraph.shared.resolver.force(
    RequestAuthorizationInteractor.self
  )

  init(
    context: ISO18013MobileDocumentRequestContext?,
  ) {
    self.context = context
    super.init(
      initialState: .init(
        items: [],
        errorMessage: nil,
        isLoading: true,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
          ),
          description: .dataSharingTitle
        ),
        warning: nil
      )
    )
  }

  /// Accept waits for the user to acknowledge the warning, as Share does in the app.
  var canAccept: Bool {
    viewState.warning == nil || isRiskAcknowledged
  }

  /// Asks for the wallet PIN or biometrics before anything of the request is loaded. The view calls it
  /// on every appearance, so it does nothing once the user has authenticated.
  func initialize() {
    guard !isRequestAuthorized, !showBiometryView else { return }
    showBiometryView = true
  }

  /// The first authentication loads and shows the request; the one after Accept sends the response.
  /// Only the success that closes the presented biometry screen counts, so a second signal from the
  /// same screen cannot stand in for Accept.
  func handleBiometryAuthenticated() {
    guard showBiometryView else { return }
    showBiometryView = false
    let isAccepting = isRequestAuthorized
    isRequestAuthorized = true
    Task {
      if isAccepting {
        await acceptVerification()
      } else {
        await loadRequest()
      }
    }
  }

  func loadRequest() async {
    do {
      guard let context else {
        return
      }

      let uiModel = try await interactor.loadRequestData(context: context)

      setState {
        $0.copy(
          items: uiModel.documents.toRequestItems(),
          isLoading: false,
          contentHeaderConfig: .init(
            appIconAndTextData: AppIconAndTextData(
              appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
            ),
            description: .dataSharingTitle,
            mainText: .dataSharingRequest,
            relyingPartyData: RelyingPartyData(
              isVerified: uiModel.isRelyingPartyVerified,
              name: .custom(uiModel.issuerName),
              description: .requestsTheFollowing
            )
          ),
          warning: uiModel.isRelyingPartyVerified ? nil : .accessCertificateNotTrusted
        )
      }
    } catch let error {
      setState {
        $0.copy(
          errorMessage: error.localizedDescription,
          isLoading: false
        )
      }
    }
  }

  /// Sends the response, unless a warning is still waiting for the user's acknowledgement.
  func acceptVerification() async {
    guard canAccept else { return }
    setState {
      $0.copy(
        isLoading: true
      )
    }

    do {
      guard let context else {
        return
      }

      try await interactor.acceptVerification(context: context)
    } catch {
      setState {
        $0.copy(
          errorMessage: error.localizedDescription
        )
      }
    }
  }

  func cancelRequest() {
    context?.cancel()
  }

  /// The login texts before the request is shown, the confirmation texts after Accept. Neither has a back
  /// action: `ProviderBiometryRouter.pop()` is the success signal.
  func createBiometryConfig() -> UIConfig.Biometry {
    guard isRequestAuthorized else {
      return UIConfig.Biometry(
        navigationTitle: .enterYourPin,
        title: .loginTitle,
        caption: .loginCaption,
        quickPinOnlyCaption: .loginCaptionQuickPinOnly,
        navigationSuccessType: .pop,
        navigationBackType: nil,
        isPreAuthorization: true,
        shouldInitializeBiometricOnCreate: true,
        displayNavigationBar: false
      )
    }
    return UIConfig.Biometry(
      navigationTitle: .biometryConfirmRequest,
      caption: .requestDataShareBiometryCaption,
      quickPinOnlyCaption: .requestDataShareQuickPinCaption,
      pinTextFieldTitle: .enterYourPin,
      navigationSuccessType: .pop,
      navigationBackType: nil,
      isPreAuthorization: false,
      shouldInitializeBiometricOnCreate: true,
      displayNavigationBar: false
    )
  }
}
