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
import WalletStorage
import logic_storage

/// Timing of deferred credential requests: wait the interval sent by the issuer, never less than
/// `minimumInterval` (also used when the issuer sends none). No upper limit.
enum DeferredIssuanceSchedule {

  static let minimumInterval: TimeInterval = 5

  static func nextAttempt(after date: Date, interval: TimeInterval?) -> Date {
    date.addingTimeInterval(max(interval ?? minimumInterval, minimumInterval))
  }

  /// Stores the interval as the issuer sent it; only the wait is clamped to `minimumInterval`.
  static func pending(identifier: String, interval: TimeInterval?, at date: Date) -> DeferredIssuance {
    DeferredIssuance(
      identifier: identifier,
      nextAttemptAt: nextAttempt(after: date, interval: interval),
      interval: interval
    )
  }

  static func entries(for documents: [WalletStorage.Document], at date: Date) -> [DeferredIssuance] {
    documents
      .filter { $0.status == .deferred }
      .map { pending(identifier: $0.id, interval: $0.deferredIssuanceInterval, at: date) }
  }
}
