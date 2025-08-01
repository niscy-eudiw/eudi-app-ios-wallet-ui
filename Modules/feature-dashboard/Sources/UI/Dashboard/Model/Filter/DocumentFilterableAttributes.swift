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
import Foundation
import logic_business

struct DocumentFilterableAttributes: FilterableAttributes {
  let sortingKey: String
  let searchTags: [String]
  let issuedDate: Date?
  let expiryDate: Date?
  let issuer: String?
  let name: String?
  let category: String?
  let isRevoked: Bool

  init(
    sortingKey: String,
    searchTags: [String],
    issuedDate: Date? = nil,
    expiryDate: Date? = nil,
    issuer: String? = nil,
    name: String? = nil,
    category: String? = nil,
    isRevoked: Bool = false
  ) {
    self.sortingKey = sortingKey
    self.searchTags = searchTags
    self.issuedDate = issuedDate
    self.expiryDate = expiryDate
    self.issuer = issuer
    self.name = name
    self.category = category
    self.isRevoked = isRevoked
  }
}
