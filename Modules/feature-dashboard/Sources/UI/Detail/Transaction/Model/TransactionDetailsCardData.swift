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
import Foundation
import logic_resources
import logic_business

public struct TransactionDetailsCardData: Equatable, Identifiable, Sendable {

  @EquatableNoop
  public var id: String

  public let transactionTypeLabel: LocalizableStringKey
  public let transactionStatusLabel: LocalizableStringKey
  public let transactionIsCompleted: Bool
  public let transactionDate: LocalizableStringKey
  public let partyLabel: LocalizableStringKey
  public let partyName: LocalizableStringKey?
  public let partySubtitles: [LocalizableStringKey]
  public let nonCompletionReason: LocalizableStringKey?
  public let details: [[TransactionDetailsFieldUi]]

  init(
    id: String = UUID().uuidString,
    transactionTypeLabel: LocalizableStringKey,
    transactionStatusLabel: LocalizableStringKey,
    transactionIsCompleted: Bool,
    transactionDate: LocalizableStringKey,
    partyLabel: LocalizableStringKey,
    partyName: LocalizableStringKey? = nil,
    partySubtitles: [LocalizableStringKey] = [],
    nonCompletionReason: LocalizableStringKey? = nil,
    details: [[TransactionDetailsFieldUi]] = []
  ) {
    self.id = id
    self.transactionTypeLabel = transactionTypeLabel
    self.transactionStatusLabel = transactionStatusLabel
    self.transactionIsCompleted = transactionIsCompleted
    self.transactionDate = transactionDate
    self.partyLabel = partyLabel
    self.partyName = partyName
    self.partySubtitles = partySubtitles
    self.nonCompletionReason = nonCompletionReason
    self.details = details
  }
}

extension TransactionDetailsCardData {
  static func mock() -> TransactionDetailsCardData {
    TransactionDetailsCardData(
      transactionTypeLabel: .custom("Presentation"),
      transactionStatusLabel: .custom("Completed"),
      transactionIsCompleted: true,
      transactionDate: .custom("24 Apr 2025 10:30"),
      partyLabel: .transactionDetailsRelyingPartyLabel,
      partyName: .custom("EUDI remote verifier")
    )
  }
}
