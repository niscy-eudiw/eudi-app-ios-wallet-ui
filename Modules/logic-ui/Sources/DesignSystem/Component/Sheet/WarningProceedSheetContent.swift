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
import SwiftUI
import logic_resources

public struct WarningProceedSheetContent: View {

  private let title: LocalizableStringKey
  private let message: LocalizableStringKey
  private let onProceed: () -> Void
  private let onCancel: () -> Void

  public init(
    title: LocalizableStringKey,
    message: LocalizableStringKey,
    onProceed: @escaping () -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.title = title
    self.message = message
    self.onProceed = onProceed
    self.onCancel = onCancel
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

      HStack(spacing: SPACING_SMALL) {
        Theme.shared.image.exclamationmarkTriangleFill
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(width: 28, height: 28)
          .foregroundStyle(Theme.shared.color.warning)

        Text(title)
          .typography(Theme.shared.font.titleLarge)
          .fontWeight(.semibold)
          .foregroundColor(Theme.shared.color.primaryLabel)

        Spacer(minLength: SPACING_NONE)
      }

      Text(message)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundColor(Theme.shared.color.primaryLabel)
        .frame(maxWidth: .infinity, alignment: .leading)

      WrapButtonView(
        style: .primary,
        title: .continueButton,
        onAction: onProceed()
      )

      WrapButtonView(
        style: .secondary,
        title: .cancelButton,
        onAction: onCancel()
      )
    }
    .padding(.vertical)
  }
}

#Preview {
  WarningProceedSheetContent(
    title: .issuanceRegistrationWarningTitle,
    message: .issuanceRegistrationWarningMessage,
    onProceed: {},
    onCancel: {}
  )
}
