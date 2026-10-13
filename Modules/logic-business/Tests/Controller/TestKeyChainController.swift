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
@testable import logic_business
@testable import logic_test

final class TestKeyChainController: EudiTest {

  func testValidateBiometricItem_WhenItemIsMissing_ThenThrowsItemNotFound() {
    XCTAssertThrowsError(
      try KeyChainControllerImpl.validateBiometricItem(nil, value: "written")
    ) { error in
      XCTAssertEqual(error as? KeyChainError, .itemNotFound)
    }
  }

  func testValidateBiometricItem_WhenItemDiffersFromWrittenValue_ThenThrowsItemNotFound() {
    XCTAssertThrowsError(
      try KeyChainControllerImpl.validateBiometricItem("other", value: "written")
    ) { error in
      XCTAssertEqual(error as? KeyChainError, .itemNotFound)
    }
  }

  func testValidateBiometricItem_WhenItemMatchesWrittenValue_ThenSucceeds() {
    XCTAssertNoThrow(
      try KeyChainControllerImpl.validateBiometricItem("written", value: "written")
    )
  }
}
