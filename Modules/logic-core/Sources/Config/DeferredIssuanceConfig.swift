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

/// Timing of deferred credential requests, shared by all deferred documents, as the Android wallet's
/// `DeferredIssuanceConfig`. In seconds. The issuer's interval is waited in full when it is longer, and no
/// wait is shorter than `DeferredIssuanceSchedule.minimumInterval`.
struct DeferredIssuanceConfig: Sendable, Equatable {

  /// Wait before the next request when the issuer sends no interval.
  let initialPollingDelay: TimeInterval
  /// Wait after the first transient failure. It doubles with each further failure in a row.
  let failureRetryDelay: TimeInterval
  /// Longest wait after transient failures.
  let maximumFailureRetryDelay: TimeInterval
  /// Transient failures in a row after which the document is no longer requested and shows as failed.
  /// A failure without a network connection doesn't count.
  let maxConsecutiveFailedAttempts: Int

  init(
    initialPollingDelay: TimeInterval,
    failureRetryDelay: TimeInterval,
    maximumFailureRetryDelay: TimeInterval,
    maxConsecutiveFailedAttempts: Int
  ) {
    precondition(initialPollingDelay.isFinite && initialPollingDelay > 0)
    precondition(failureRetryDelay.isFinite && failureRetryDelay > 0)
    precondition(maximumFailureRetryDelay.isFinite && maximumFailureRetryDelay >= failureRetryDelay)
    precondition(maxConsecutiveFailedAttempts > 0)
    self.initialPollingDelay = initialPollingDelay
    self.failureRetryDelay = failureRetryDelay
    self.maximumFailureRetryDelay = maximumFailureRetryDelay
    self.maxConsecutiveFailedAttempts = maxConsecutiveFailedAttempts
  }
}
