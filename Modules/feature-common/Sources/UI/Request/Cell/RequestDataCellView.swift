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
import SwiftUI
import logic_resources
import logic_ui

extension BaseRequestView {
  struct RequestDataCellView: View {

    typealias Cell = RequestDataCell
    typealias TapListener = ((String) -> Void)?

    let cellModel: Cell
    let isLoading: Bool
    let onTap: TapListener

    init(cellModel: Cell, isLoading: Bool, onTap: TapListener = nil) {
      self.cellModel = cellModel
      self.isLoading = isLoading
      self.onTap = onTap
    }

    var body: some View {
      switch cellModel {
      case .requestDataRow(let row):
        WrapCheckBoxView(
          isSelected: row.isSelected,
          isVisible: row.isVisible,
          isEnabled: true,
          isLoading: isLoading,
          id: row.id,
          title: row.title,
          value: row.value,
          onTap: self.onTap
        )
        .padding(.bottom)
      case .requestDataSection(let section):
        HStack(spacing: .zero) {

          HStack(spacing: SPACING_SMALL) {

            ThemeManager.shared.image.idStroke
              .resizable()
              .scaledToFit()
              .frame(width: 45)

            Text(section.title)
              .typography(ThemeManager.shared.font.titleMedium)
              .foregroundStyle(ThemeManager.shared.color.primary)
          }
          .padding([.horizontal, .vertical], SPACING_SMALL)
          .overlay(
            RoundedRectangle(cornerRadius: 15)
              .foregroundStyle(ThemeManager.shared.color.primary.opacity(0.2))
          )

          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.bottom)
        .disabled(isLoading)
        .shimmer(isLoading: isLoading)
      case .requestDataVerification(let verification):
        ContentExpandable(title: .custom(verification.title)) {

          VStack(spacing: SPACING_LARGE) {

            ForEach(verification.items, id: \.id) {
              WrapCheckBoxView(
                isSelected: $0.isSelected,
                isVisible: $0.isVisible,
                isEnabled: false,
                isLoading: isLoading,
                id: $0.id,
                title: $0.title,
                value: $0.value
              )
            }
          }
        }
        .padding(.bottom)
        .shimmer(isLoading: isLoading)
      }
    }
  }
}