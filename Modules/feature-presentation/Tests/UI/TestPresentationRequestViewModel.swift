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
@testable import logic_core
@testable import feature_common
@testable import feature_presentation
@testable import logic_test
@testable import feature_test

final class TestPresentationRequestViewModel: EudiTest {

  @MainActor
  func testDoWork_WhenTheVerifierDidNotAuthenticate_ThenWarnsAboutItsAccessCertificate() async {
    let viewModel = makeViewModel(isTrusted: false)

    await viewModel.doWork()

    XCTAssertEqual(viewModel.viewState.registrationWarning, .accessCertificateNotTrusted)
  }

  @MainActor
  func testDoWork_WhenTheVerifierAuthenticated_ThenShowsNoWarning() async {
    let viewModel = makeViewModel(isTrusted: true)

    await viewModel.doWork()

    XCTAssertNil(viewModel.viewState.registrationWarning)
  }

  @MainActor
  private func makeViewModel(isTrusted: Bool) -> PresentationRequestViewModel<MockRouterHost> {
    let interactor = MockPresentationInteractor()
    stub(interactor) { mock in
      when(mock.getCoordinator()).thenReturn(.failure(RuntimeError.genericError))
      when(mock.onDeviceEngagement()).thenReturn(
        .success(
          OnlineAuthenticationRequestSuccessModel(
            requestDataCombinations: [],
            relyingParty: "Verifier",
            dataRequestInfo: "",
            isTrusted: isTrusted,
            relyingPartyRegistration: RelyingPartyRegistration(
              name: nil,
              uniqueId: nil,
              isVerified: false,
              logoUrl: nil,
              registration: .notSupported
            )
          )
        )
      )
    }
    return PresentationRequestViewModel(
      router: MockRouterHost(),
      interactor: interactor,
      originator: .featureDashboardModule(.dashboard)
    )
  }
}
