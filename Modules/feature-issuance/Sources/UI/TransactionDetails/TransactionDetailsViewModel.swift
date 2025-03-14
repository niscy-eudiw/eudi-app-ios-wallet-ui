/*
 * Copyright (c) 2023 European Commission
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
import Foundation
import logic_ui
import logic_resources
import logic_business
import feature_common
import logic_core

@Copyable
struct TransactionDetailsViewState: ViewState {
  let title: LocalizableStringKey
  let detailsDataSharedSection: LocalizableStringKey
  let detailsDataSignedSection: LocalizableStringKey
  let error: ContentErrorView.Config?
  var isLoading: Bool
}

final class TransactionDetailsViewModel<Router: RouterHost>: ViewModel<Router, TransactionDetailsViewState> {

  private let interactor: TransactionDetailsInteractor

  init(
    router: Router,
    interactor: TransactionDetailsInteractor
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        title: .transactionInformation,
        detailsDataSharedSection: .transactionDetailsDataShare,
        detailsDataSignedSection: .transactionDetailsDataSigned,
        error: nil,
        isLoading: false
      )
    )
  }

  func toolbarContent() -> ToolBarContent? {
    .init(
      trailingActions: [],
      leadingActions: [
        Action(image: Theme.shared.image.chevronLeft) {
          self.pop()
        }
      ]
    )
  }

  func pop() {
    router.popTo(with: .featureDashboardModule(.dashboard))
  }
}
