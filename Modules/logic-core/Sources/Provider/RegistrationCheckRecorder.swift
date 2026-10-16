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

/// Holds the registration outcome of the presentation in progress until wallet-kit writes its history entry.
public protocol RegistrationCheckRecorder: Sendable {
  func record(_ check: RecordedRegistrationCheck) async
  /// The outcome recorded since the last call, which it clears.
  func take() async -> RecordedRegistrationCheck?
}

final actor RegistrationCheckRecorderImpl: RegistrationCheckRecorder {

  private var check: RecordedRegistrationCheck?

  func record(_ check: RecordedRegistrationCheck) {
    self.check = check
  }

  func take() -> RecordedRegistrationCheck? {
    defer { check = nil }
    return check
  }
}
