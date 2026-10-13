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

public protocol SystemBiometryController: Sendable {
  func getBiometryType() async -> LABiometryType
  func requestBiometricUnlock() async throws
  func openSettings(action: @escaping @Sendable () -> Void) async
}

final actor SystemBiometryControllerImpl: SystemBiometryController {

  private let context: LAContext
  private let evaluationContextProvider: @Sendable () -> LAContext
  private let keyChainController: KeyChainController

  /// - Parameter evaluationContextProvider: Creates the context for each unlock attempt. A context that
  ///   has evaluated once keeps succeeding without a prompt, so it is never reused.
  public init(
    context: LAContext = LAContext(),
    evaluationContextProvider: @escaping @Sendable () -> LAContext = { LAContext() },
    keyChainController: KeyChainController
  ) {
    self.context = context
    self.evaluationContextProvider = evaluationContextProvider
    self.keyChainController = keyChainController
  }

  deinit {
    context.invalidate()
  }

  public func getBiometryType() async -> LABiometryType {
    context.biometryType
  }

  /// Succeeds only after the system has evaluated the biometric policy on a new context and the
  /// keychain probe has been read with that context. The system's passcode fallback is hidden, as
  /// on the keychain prompt this replaces; the wallet PIN is the fallback.
  public func requestBiometricUnlock() async throws {

    try canEvaluateForBiometrics()

    let evaluationContext = evaluationContextProvider()
    evaluationContext.localizedFallbackTitle = ""
    defer { evaluationContext.invalidate() }

    do {
      let isAuthenticated = try await evaluationContext.evaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        localizedReason: LocalizableStringKey.biometryUnlockReason.toString
      )
      guard isAuthenticated else {
        throw SystemBiometryError.biometricError
      }
      try keyChainController.validateKeyChainBiometry(with: evaluationContext)
    } catch {
      keyChainController.clearKeyChainBiometry()
      throw SystemBiometryError.biometricError
    }
  }

  @MainActor
  public func openSettings(action: @escaping @Sendable () -> Void) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:]) { success in
      guard success else { return }
      action()
    }
  }

  private func canEvaluateForBiometrics() throws {

    var nsError: NSError?

    let canEvaluate = context.canEvaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      error: &nsError
    )

    if !canEvaluate {
      if let error = nsError {
        switch error.code {
        case -6:
          throw SystemBiometryError.deniedAccess
        case -7:
          if context.biometryType == .faceID {
            throw SystemBiometryError.noFaceIdEnrolled
          } else {
            throw SystemBiometryError.noFingerprintEnrolled
          }
        default:
          throw SystemBiometryError.biometricError
        }
      }
      throw SystemBiometryError.deniedAccess
    }

    guard context.biometryType != .none else {
      throw SystemBiometryError.biometryNotSupported
    }
  }
}
