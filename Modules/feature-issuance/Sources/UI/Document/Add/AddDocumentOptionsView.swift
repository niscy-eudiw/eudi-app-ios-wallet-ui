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
import SwiftUI
import logic_ui
import logic_resources

struct AddDocumentOptionsView<Router: RouterHost>: View {
  @ObservedObject var viewModel: AddDocumentOptionsViewModel<Router>

  init(with viewModel: AddDocumentOptionsViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      allowBackGesture: true,
      navigationTitle: LocalizableString.shared.get(with: .addDocumentTitle)
    ) {
      content(
        onAddDocumentClick: { viewModel.onAddDocumentClick() },
        onScanClick: { viewModel.onScanClick() }
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  onAddDocumentClick: @escaping () -> Void,
  onScanClick: @escaping () -> Void
) -> some View {
  VStack(spacing: SPACING_LARGE_MEDIUM) {
    Text(.addDocumentsToWallet)
      .typography(Theme.shared.font.bodyMedium)
      .foregroundStyle(Theme.shared.color.onSurface)

    VStack(spacing: SPACING_MEDIUM_SMALL) {
      ActionCard(
        icon: Theme.shared.image.chooseDocumentImage,
        title: LocalizableString.shared.get(with: .chooseFromList),
        action: {
          onAddDocumentClick()
        }
      )

      ActionCard(
        icon: Theme.shared.image.scanDocumentImage,
        title: LocalizableString.shared.get(with: .scanQrCode),
        action: {
          onScanClick()
        }
      )
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  .padding(.horizontal, Theme.shared.dimension.padding)
}

#Preview {
  ContentScreenView(
    padding: .zero,
    canScroll: true,
    allowBackGesture: true,
    navigationTitle: LocalizableString.shared.get(with: .addDocumentTitle)
  ) {
    content(onAddDocumentClick: {}, onScanClick: {})
  }
}