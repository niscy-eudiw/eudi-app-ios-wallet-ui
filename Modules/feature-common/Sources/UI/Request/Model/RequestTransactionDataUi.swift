/*
 * Copyright (c) 2025 European Commission
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
import logic_core
import logic_ui
import Copyable

@Copyable
public struct RequestTransactionDataUi: Identifiable, Sendable, Equatable {
  @EquatableNoop
  public var id: String
  
  public let type: TransactionDataType
  public let section: PresentationListItemSection
  
  public init(
    id: String = UUID().uuidString,
    type: TransactionDataType,
    section: PresentationListItemSection,
  ) {
    self.id = id
    self.type = type
    self.section = section
  }
}

// TODO: replace transaction data from wallet kit controller
public extension RequestTransactionDataUi {
  static func mocks() -> RequestTransactionDataUi {
    RequestTransactionDataUi(
      type: .sign,
      section: .init(
        id: UUID().uuidString,
        title: "",
        listItems: [
          .single(
            .init(
              collapsed: ListItemData(
                mainText: .custom("Item 1"),
                overlineText: .custom("Item 1 Description")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: ListItemData(
                mainText: .custom("https://www.google.com"),
                overlineText: .custom("Item 2 Description")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: ListItemData(
                mainText: .custom("Item 3"),
                overlineText: .custom("Item 3 Description")
              ),
              domainModel: nil
            )
          )
        ]
      )
    )
  }
}

public enum TransactionDataType: Sendable {
  case sign
  
  func getDescription() -> LocalizableStringKey {
    switch self {
    case .sign:
      .requestTransactionDataDescriptionSign
    }
  }
  
  func getSectionTitle() -> LocalizableStringKey {
    switch self {
    case .sign:
      .requestTransactionDataSectionTitleSign
    }
  }
}
