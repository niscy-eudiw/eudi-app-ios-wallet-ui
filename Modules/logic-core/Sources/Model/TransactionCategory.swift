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

public enum TransactionCategory: Hashable, Equatable, Sendable {
  case today
  case thisWeek
  case month(dateTime: String)

  public var title: String {
    return switch self {
    case .today:
      "TODAY"
    case .thisWeek:
      "THIS WEEK"
    case .month(let dateTime):
      dateTime
    }
  }

  public var order: Int {
    return switch self {
    case .today:
      0
    case .thisWeek:
      1
    case .month:
      2
    }
  }
}
