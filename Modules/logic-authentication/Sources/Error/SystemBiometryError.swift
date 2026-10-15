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

@preconcurrency import LocalAuthentication
import logic_business
import logic_resources
import UIKit

public enum SystemBiometryError: Error, LocalizedError, Identifiable, Sendable {
  case deniedAccess
  case noFaceIdEnrolled
  case noFingerprintEnrolled
  case biometricError
  case biometryNotSupported

  public var id: String { localizedDescription }

  public var errorDescription: String? {
    switch self {
    case .deniedAccess:
      return NSLocalizedString(
        "You have denied access. Please go to the settings, locate this application and turn the Face ID on",
        comment: ""
      )
    case .noFaceIdEnrolled:
      return NSLocalizedString("You have not enabled Face ID yet", comment: "")
    case .noFingerprintEnrolled:
      return NSLocalizedString("You have not enabled fingerprint yet", comment: "")
    case .biometricError:
      return NSLocalizedString("Your biometric method has not been recognized", comment: "")
    case .biometryNotSupported:
      return NSLocalizedString("This device does not support biometry", comment: "")
    }
  }
}
