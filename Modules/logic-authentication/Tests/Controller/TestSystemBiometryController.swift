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
import XCTest
import Combine
@testable import logic_test
@testable import logic_authentication
@preconcurrency import LocalAuthentication

final class TestSystemBiometryController: EudiTest {

  class StubLAContext: LAContext {
    var canEvaluateReturn = true
    var evaluateError: NSError? = nil

    var stubBiometryType: LABiometryType = .touchID
    override var biometryType: LABiometryType { stubBiometryType }

    override func canEvaluatePolicy(
      _ policy: LAPolicy,
      error: NSErrorPointer
    ) -> Bool {
      if let e = evaluateError {
        error?.pointee = e
      }
      return canEvaluateReturn
    }

    var evaluatePolicyResult: (success: Bool, error: Error?) = (true, nil)
    override func evaluatePolicy(
      _ policy: LAPolicy,
      localizedReason: String,
      reply: @escaping (Bool, Error?) -> Void
    ) {
      reply(evaluatePolicyResult.success, evaluatePolicyResult.error)
    }

    override func invalidate() {}
  }

  var biometryController: SystemBiometryController!
  var keyChainController: MockKeyChainController!
  var context: StubLAContext!
  var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()
    self.keyChainController = MockKeyChainController()
    self.context = StubLAContext()
    self.biometryController = SystemBiometryControllerImpl(
      context: context,
      keyChainController: keyChainController
    )
  }

  override func tearDown() {
    self.cancellables.removeAll()
    self.biometryController = nil
    self.keyChainController = nil
    self.context = nil
  }

  func testRequestUnlock_WhenPolicyDenied_ThenDeniedAccess() {
    context.canEvaluateReturn = false
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.userCancel.rawValue,
      userInfo: nil
    )

    let exp = expectation(description: "deniedAccess")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .deniedAccess)
            exp.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not send value when policy is denied")
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenFaceID_ThenNoFaceIdEnrolled() {
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )

    context.stubBiometryType = .faceID

    let exp = expectation(description: "noFaceIdEnrolled")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .noFaceIdEnrolled)
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail("Should not send a value") }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenTouchID_ThenNoFingerprintEnrolled() {
    context.canEvaluateReturn = true
    context.evaluateError = NSError(
      domain: LAErrorDomain,
      code: LAError.Code.biometryNotEnrolled.rawValue,
      userInfo: nil
    )
    context.stubBiometryType = .touchID

    let exp = expectation(description: "noFingerprintEnrolled")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .noFingerprintEnrolled)
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenBiometryNotSupported_yieldsBiometryNotSupported() {
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .none

    let exp = expectation(description: "biometryNotSupported")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .biometryNotSupported)
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenKeychainValidates_ThenReturnSuccess() {
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID

    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry()).thenDoNothing()
    }

    let exp = expectation(description: "success")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTFail("Expected success but got \(err)")
          }
        },
        receiveValue: {
          exp.fulfill()
        }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }

  func testRequestBiometricUnlock_WhenKeychainThrows_ThenReturnBiometricError() {
    context.canEvaluateReturn = true
    context.evaluateError = nil
    context.stubBiometryType = .touchID

    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenThrow(SystemBiometryError.biometricError)
      when(stub.clearKeyChainBiometry())
        .thenDoNothing()
    }

    let exp = expectation(description: "biometricError")
    biometryController.requestBiometricUnlock()
      .sink(
        receiveCompletion: { completion in
          if case let .failure(err) = completion {
            XCTAssertEqual(err, .biometricError)
            exp.fulfill()
          }
        },
        receiveValue: { _ in XCTFail() }
      )
      .store(in: &cancellables)

    wait(for: [exp], timeout: 0.5)
  }
}

extension TestSystemBiometryController {
  func stubValidateKeyChainBiometrySuccess() {
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenDoNothing()
    }
  }

  func stubValidateKeyChainBiometryFailure() {
    stub(keyChainController) { stub in
      when(stub.validateKeyChainBiometry())
        .thenThrow(SystemBiometryError.biometricError)
      when(stub.clearKeyChainBiometry())
        .thenDoNothing()
    }
  }
}
