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
import SwiftUI
import logic_core
import logic_resources
import logic_business
import logic_ui

public struct TransactionUIModel: Identifiable, Sendable {
  public let id: String
  public let name: String
  public let status: TransactionStatus
  public let transactionDate: String

  public init(
    id: String = UUID().uuidString,
    name: String,
    status: TransactionStatus,
    transactionDate: String
  ) {
    self.id = id
    self.name = name
    self.status = status
    self.transactionDate = transactionDate
  }

  public var listItem: ListItemData {
    return ListItemData(
      mainText: .custom(name),
      overlineText: .custom(status.rawValue),
      supportingText: .custom(transactionDate),
      supportingTextColor: Theme.shared.color.onSurface,
      overlineTextColor: status == .completed ? Theme.shared.color.success : Theme.shared.color.error,
      trailingContent: .icon(Theme.shared.image.chevronRight, Theme.shared.color.onSurfaceVariant)
    )
  }

  static func mocks() -> [TransactionUIModel] {
    return [
      TransactionUIModel(
        name: "Document Signing",
        status: .completed,
        transactionDate: "03 March 2025 09:20 AM"
      ),
      TransactionUIModel(
        name: "Data Sharing Request",
        status: .completed,
        transactionDate: "03 March 2025 09:20 AM"
      ),
      TransactionUIModel(
        name: "Data Sharing Request",
        status: .completed,
        transactionDate: "06 Mar 2025 09:20 AM"
      ),
      TransactionUIModel(
        name: "Document Signing",
        status: .completed,
        transactionDate: "06 Mar 2025 09:20 AM"
      ),
      TransactionUIModel(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "24 Feb 2025 11:07 AM"
      ),
      TransactionUIModel(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "14 Jan 2025 11:07 AM"
      ),
      TransactionUIModel(
        name: "Another Document Signing",
        status: .completed,
        transactionDate: "14 Feb 2024 11:07 AM"
      ),
      TransactionUIModel(
        name: "PID Presentation",
        status: .failed,
        transactionDate: "03 Jan 2024 11:07 AM"
      )
    ]
  }

  static func categorizeTransactions(_ transactions: [TransactionUIModel]) -> [TransactionCategory: [TransactionUIModel]] {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy h:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    let calendar = Calendar.current
    let now = Date()

    let sortedTransactions = transactions.sorted {
      guard let date1 = formatter.date(from: $0.transactionDate),
            let date2 = formatter.date(from: $1.transactionDate) else {
        return false
      }
      let year1 = calendar.component(.year, from: date1)
      let year2 = calendar.component(.year, from: date2)
      let month1 = calendar.component(.month, from: date1)
      let month2 = calendar.component(.month, from: date2)
      let day1 = calendar.component(.day, from: date1)
      let day2 = calendar.component(.day, from: date2)

      if year1 != year2 {
        return year1 > year2
      }
      if month1 != month2 {
        return month1 > month2
      }
      return day1 > day2
    }

    return Dictionary(grouping: sortedTransactions) { transaction in
      guard let date = formatter.date(from: transaction.transactionDate) else {
        return .month(dateTime: "UNKNOWN")
      }

      if calendar.isDateInToday(date) {
        return .today
      } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
        return .thisWeek
      } else {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy"
        monthFormatter.locale = Locale(identifier: "en_US_POSIX")
        return .month(dateTime: monthFormatter.string(from: date).uppercased())
      }
    }
  }
}

public enum TransactionStatus: String, CaseIterable, Sendable {
  case completed = "Completed"
  case failed = "Failed"
}
