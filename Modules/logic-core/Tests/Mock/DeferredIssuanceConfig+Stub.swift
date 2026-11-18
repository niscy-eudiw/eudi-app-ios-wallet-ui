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
@testable import logic_core

extension DeferredIssuanceConfig {
  /// The wallet's own timing: 5 s without an interval, then 30 s doubling up to an hour after failures,
  /// up to 5 failures in a row.
  static let stub = DeferredIssuanceConfig(
    initialPollingDelay: 5,
    failureRetryDelay: 30,
    maximumFailureRetryDelay: 3600,
    maxConsecutiveFailedAttempts: 5
  )
}
