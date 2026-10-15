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

final class TestGenericSuccessViewModel: EudiTest {

  @MainActor
  func testOnButtonClicked_WhenTheButtonOpensAWebPage_ThenOpensItAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "https://verifier.example/done"))
    let (viewModel, button, router, opened) = makeViewModel(redirect: redirect)

    viewModel.onButtonClicked(with: button)

    XCTAssertEqual(opened.urls, [redirect])
    verify(router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
  }

  @MainActor
  func testOnButtonClicked_WhenTheButtonOpensAWalletLink_ThenOpensNothingAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "rqes://callback?code=abc"))
    let (viewModel, button, router, opened) = makeViewModel(redirect: redirect)

    viewModel.onButtonClicked(with: button)

    XCTAssertTrue(opened.urls.isEmpty)
    verify(router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
  }
}

private extension TestGenericSuccessViewModel {

  @MainActor
  func makeViewModel(
    redirect: URL
  ) -> (GenericSuccessViewModel<MockRouterHost>, UIConfig.Success.Button, MockRouterHost, RecordingLinkOpener) {
    let router = MockRouterHost()
    stub(router) { mock in
      when(mock.popTo(with: any())).thenDoNothing()
    }
    let opened = RecordingLinkOpener()
    let button = UIConfig.Success.Button(
      title: .custom("Done"),
      style: .primary,
      navigationType: .deepLink(link: redirect, popToScreen: .featureDashboardModule(.dashboard))
    )
    let viewModel = GenericSuccessViewModel(
      config: UIConfig.Success(
        title: .init(value: .custom("Done")),
        subtitle: .custom(""),
        buttons: [button],
        visualKind: .defaultIcon
      ),
      router: router,
      openURL: { opened.open($0) }
    )
    return (viewModel, button, router, opened)
  }
}
