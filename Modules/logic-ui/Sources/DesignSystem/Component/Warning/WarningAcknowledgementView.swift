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

public struct WarningAcknowledgementView: View {
  private let message: LocalizableStringKey
  private let acknowledgementText: LocalizableStringKey
  @Binding private var isAcknowledged: Bool

  public init(
    message: LocalizableStringKey,
    acknowledgementText: LocalizableStringKey = .understandRisksAgree,
    isAcknowledged: Binding<Bool>
  ) {
    self.message = message
    self.acknowledgementText = acknowledgementText
    self._isAcknowledged = isAcknowledged
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      HStack(alignment: .top, spacing: SPACING_SMALL) {
        Theme.shared.image.exclamationmarkTriangleFill
          .foregroundColor(foregroundColor)

        Text(message)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(foregroundColor)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Divider()
        .overlay(foregroundColor)

      Toggle(isOn: $isAcknowledged) {
        Text(acknowledgementText)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(foregroundColor)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
      }
      .tint(foregroundColor)
    }
    .padding(SPACING_MEDIUM)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Theme.shared.color.warning)
    .clipShape(RoundedRectangle(cornerRadius: SPACING_SMALL))
  }

  private var foregroundColor: Color {
    Theme.shared.color.white
  }
}

#Preview("Off") {
  StatefulPreviewWrapper(false) { isOn in
    WarningAcknowledgementView(
      message: .relyingPartyNotVerifiedWarning,
      isAcknowledged: isOn
    )
    .padding()
  }
}

#Preview("On") {
  StatefulPreviewWrapper(true) { isOn in
    WarningAcknowledgementView(
      message: .custom(
        "Warning: Some of the requested data are not registered with this interacting party. Review carefully before sharing your data."
      ),
      isAcknowledged: isOn
    )
    .padding()
  }
}

private struct StatefulPreviewWrapper<Content: View>: View {
  @State private var value: Bool
  private let content: (Binding<Bool>) -> Content

  init(_ initialValue: Bool, @ViewBuilder content: @escaping (Binding<Bool>) -> Content) {
    self._value = State(initialValue: initialValue)
    self.content = content
  }

  var body: some View {
    content($value)
  }
}
