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
import XCTest
import logic_authentication
import logic_business
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestQuickPinInteractor: EudiTest {

  var interactor: QuickPinInteractor!
  var pinStorageController: MockPinStorageController!
  var pinThrottleController: MockPinThrottleController!
  var authenticationConfig: MockAuthenticationConfig!

  override func setUp() {
    self.pinStorageController = MockPinStorageController()
    self.pinThrottleController = MockPinThrottleController()
    self.authenticationConfig = MockAuthenticationConfig()
    
    stub(authenticationConfig) { mock in
      when(mock.maxFailedPinAttempts.get).thenReturn(3)
      when(mock.pinLockoutDurations.get).thenReturn([30, 90, 300])
    }
    
    self.interactor = QuickPinInteractorImpl(
      pinStorageController: pinStorageController,
      pinThrottleController: pinThrottleController,
      authenticationConfig: authenticationConfig
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.pinStorageController = nil
    self.pinThrottleController = nil
    self.authenticationConfig = nil
  }
  
  func testSetPin_WhenNewPinIsSet_ThenVerifyAtLeastOnce() async {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = await interactor.setPin(newPin: pin)
    
    // Then
    verify(pinStorageController).setPin(with: pin)
    guard case .success = state else {
      return XCTFail("Wrong state \(state)")
    }
  }

  func testSetPin_WhenStorageWriteFails_ThenReturnPartialStateFailure() async {
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenThrow(KeyChainError.writeFailed(status: errSecNotAvailable))
    }

    let state = await interactor.setPin(newPin: "1234")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
  }

  func testChangePin_WhenStorageWriteFails_ThenReturnPartialStateFailure() async {
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
      when(mock.setPin(with: any())).thenThrow(KeyChainError.writeFailed(status: errSecNotAvailable))
    }

    let state = await interactor.changePin(currentPin: "1234", newPin: "4321")

    guard case .failure(let error) = state else {
      return XCTFail("Wrong state \(state)")
    }
    XCTAssertEqual(error as? KeyChainError, .writeFailed(status: errSecNotAvailable))
  }

  func testHasPin_WhenStorageReadFails_ThenThrowsTheStorageError() async {
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenThrow(KeyChainError.readFailed(status: errSecInteractionNotAllowed))
    }

    do {
      _ = try await interactor.hasPin()
      XCTFail("Expected hasPin to throw")
    } catch {
      XCTAssertEqual(error as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
    }
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsMatch_ThenReturnPartialStateSuccess() async {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
    }
    
    // When
    let state = await interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testIsPinValid_WhenStoredAndProvidedPinsDoNotMatch_ThenReturnPartialStateFailure() async {
    
    // Given
    let pin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    
    // When
    let state = await interactor.isPinValid(pin: pin)
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testHasPin_WhenThereIsAStoredPin_ThenReturnTrue() async throws {
    
    // Given
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenReturn(true)
    }
    
    // When
    let answer = try await interactor.hasPin()
    
    // Then
    XCTAssertTrue(answer)
  }
  
  func testHasPin_WhenThereIsNoStoredPin_ThenReturnFalse() async throws {
    
    // Given
    stub(pinStorageController) { mock in
      when(mock.hasPin()).thenReturn(false)
    }
    
    // When
    let answer = try await interactor.hasPin()
    
    // Then
    XCTAssertFalse(answer)
  }
  
  func testChangePin_WhenCurrentPinIsValid_ThenReturnPartialStateSuccess() async {
    
    // Given
    let newPin = "4321"
    let currentPin = "1234"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(true)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }
    
    // When
    let state = await interactor.changePin(currentPin: currentPin, newPin: newPin)
    
    // Then
    verify(pinStorageController).setPin(with: newPin)
    
    switch state {
    case .success:
      XCTAssert(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testChangePin_WhenCurrentPinIsNotValid_ThenReturnPartialStateFailure() async {

    // Given
    let newPin = "4321"
    stub(pinStorageController) { mock in
      when(mock.isPinValid(with: any())).thenReturn(false)
    }
    stub(pinStorageController) { mock in
      when(mock.setPin(with: any())).thenDoNothing()
    }

    // When
    let state = await interactor.changePin(currentPin: newPin, newPin: newPin)

    // Then
    verify(pinStorageController, times(0)).setPin(with: any())

    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, AuthenticationError.quickPinInvalid.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }

  func testGetPinLockoutState_WhenThrottleControllerReturnsIdle_ThenReturnsIdle() async {
    // Given
    stub(pinThrottleController) { mock in
      when(mock.getState()).thenReturn(.idle)
    }

    // When
    let state = await interactor.getPinLockoutState()

    // Then
    XCTAssertEqual(state, .idle)
    verify(pinThrottleController).getState()
  }

  func testGetPinLockoutState_WhenThrottleControllerReturnsActiveLockout_ThenForwardsLockout() async {
    // Given
    let expected: PinLockoutState = .active(remaining: 30, total: 90)
    stub(pinThrottleController) { mock in
      when(mock.getState()).thenReturn(expected)
    }

    // When
    let state = await interactor.getPinLockoutState()

    // Then
    XCTAssertEqual(state, expected)
    verify(pinThrottleController).getState()
  }

  func testRecordPinFailure_WhenThrottleControllerReturnsLockout_ThenForwardsLockout() async {
    // Given
    let expected: PinLockoutState = .active(remaining: 60, total: 300)
    stub(pinThrottleController) { mock in
      when(mock.recordFailure()).thenReturn(expected)
    }

    // When
    let state = await interactor.recordPinFailure()

    // Then
    XCTAssertEqual(state, expected)
    verify(pinThrottleController).recordFailure()
  }

  func testResetPinThrottle_WhenCalled_ThenDelegatesToThrottleController() async {
    // Given
    stub(pinThrottleController) { mock in
      when(mock.recordSuccess()).thenDoNothing()
    }

    // When
    await interactor.resetPinThrottle()

    // Then
    verify(pinThrottleController).recordSuccess()
  }
}
