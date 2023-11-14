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
import SwiftUI
import logic_resources
import logic_business

public struct DocumentDetailsUIModel {

  public let documentName: String
  public let holdersName: String
  public let holdersImage: Image
  public let documentFields: [DocumentField]
}

public extension DocumentDetailsUIModel {

  struct DocumentField: Identifiable {
    public let id: String
    public let title: String
    public let value: String
  }

  static func mock() -> DocumentDetailsUIModel {
    DocumentDetailsUIModel(
      documentName: "Digital ID",
      holdersName: "Jane Doe",
      holdersImage: Theme.shared.image.user,
      documentFields:
        [
          .init(
            id: UUID().uuidString,
            title: "ID no",
            value: "AB12356"),
          .init(
            id: UUID().uuidString,
            title: "Nationality",
            value: "Hellenic"),
          .init(
            id: UUID().uuidString,
            title: "Place of birth",
            value: "21 Oct 1994"),
          .init(
            id: UUID().uuidString,
            title: "Height",
            value: "1,82")
        ]
      +
      Array(
        count: 6,
        createElement: DocumentField(
          id: UUID().uuidString,
          title: "Placeholder Field Title".padded(padLength: 5),
          value: "Placeholder Field Value".padded(padLength: 10)
        )
      )
    )
  }
}