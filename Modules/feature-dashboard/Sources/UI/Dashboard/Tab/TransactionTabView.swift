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
import logic_core
import logic_resources

public struct TransactionTabView: View {
  @Binding var searchQuery: String
  let transactions: [TransactionUIModel]
  let isLoading: Bool

  init(
    searchQuery: Binding<String>,
    transactions: [TransactionUIModel],
    isLoading: Bool
  ) {
    self._searchQuery = searchQuery
    self.transactions = transactions
    self.isLoading = isLoading
  }

  public var body: some View {
    let categorizedTransactions = TransactionUIModel.categorizeTransactions(transactions)
    VStack {
      if !categorizedTransactions.isEmpty && !searchQuery.isEmpty {
        ContentUnavailableView(
          title: .noResults,
          description: .noResultsDescription
        )
      } else {
        if !categorizedTransactions.isEmpty {
          List {
            ForEach(categorizedTransactions.keys.sorted(by: { $0.order < $1.order }), id: \.self) { category in
              Section(header: Text(category.title)) {
                WrapCardView {
                  VStack(spacing: 0) {
                    WrapListItemsView(listItems: categorizedTransactions[category]?.map({ transaction in
                      transaction.listItem
                    }) ?? []
                  )}
                }
                .listRowSeparator(.hidden)
              }
              .listRowInsets(.init(
                top: SPACING_SMALL,
                leading: SPACING_MEDIUM,
                bottom: .zero,
                trailing: SPACING_MEDIUM)
              )
            }
          }
          .shimmer(isLoading: isLoading)
          .listStyle(.plain)
          .scrollIndicators(.hidden)
          .clipped()
        } else {
          ContentUnavailableView(
            title: .noResults,
            description: .noResultsDescription
          )
        }
      }
    }
    .searchable(
      searchText: $searchQuery,
      backgroundColor: Theme.shared.color.background,
      onSearchTextChange: { _ in }
    )
    .background(Theme.shared.color.background)
  }
}

#Preview {
  TransactionTabView(
    searchQuery: .constant(""),
    transactions: TransactionUIModel.mocks(),
    isLoading: false
  )
}
