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

struct DocumentDetailsViewState: ViewState {
  var document: DocumentDetailsUIModel
  var isLoading: Bool
  let error: ContentError.Config?
  let documentId: String
}

@MainActor
final class DocumentDetailsViewModel<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: BaseViewModel<Router, DocumentDetailsViewState> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor,
    documentId: String
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        document: DocumentDetailsUIModel.mock(),
        isLoading: true,
        error: nil,
        documentId: documentId
      )
    )
  }

  func fetchDocumentDetails() async {

    switch await self.interactor.fetchStoredDocument(documentId: viewState.documentId) {

    case .success(let document):
      self.setNewState(
        isLoading: false,
        document: document
      )
    case .failure(let error):
      self.setNewState(
        isLoading: true,
        error: ContentError.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop()
        )
      )
    }
  }

  func pop() {
    router.pop()
  }

  private func setNewState(
    isLoading: Bool = false,
    document: DocumentDetailsUIModel? = nil,
    error: ContentError.Config? = nil
  ) {
    setState { previous in
        .init(
          document: document ?? previous.document,
          isLoading: isLoading,
          error: error,
          documentId: previous.documentId
        )
    }
  }
}