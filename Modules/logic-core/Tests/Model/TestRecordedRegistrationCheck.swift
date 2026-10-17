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
@testable import logic_core
@testable import logic_test

final class TestRecordedRegistrationCheck: EudiTest {

  func testOf_WhenTheRegistrationWasChecked_ThenRecordsItsOutcome() {
    let details = RegistrationDetails(
      tradeName: "RP", uniqueId: "rp", logoUrl: nil, intendedUse: nil, privacyPolicyUrl: nil, serviceDescription: nil
    )
    XCTAssertEqual(
      RecordedRegistrationCheck(status: .verified(details: details, overaskedClaims: []), isNotBoundToRequester: false),
      .verified
    )
    XCTAssertEqual(RecordedRegistrationCheck(status: .notVerified(details: nil), isNotBoundToRequester: false), .notVerified)
    XCTAssertEqual(
      RecordedRegistrationCheck(status: .notVerified(details: details), isNotBoundToRequester: true),
      .notBoundToRequester
    )
    XCTAssertEqual(RecordedRegistrationCheck(status: .notSupported, isNotBoundToRequester: false), .notEvaluated)
  }

  func testProvider_WhenTheOutcomeIsTaken_ThenItIsCleared() async {
    let provider = RegistrationCheckProviderImpl()
    await provider.record(.notBoundToRequester)

    let first = await provider.take()
    let second = await provider.take()

    XCTAssertEqual(first, .notBoundToRequester)
    XCTAssertNil(second)
  }

  func testPresentationRegistrationCheck_WhenTheEntryIsFirstWritten_ThenAnEarlierPresentationsOutcomeIsDropped() {
    XCTAssertNil(
      WalletKitTransactionLogControllerImpl.presentationRegistrationCheck(
        stored: nil,
        isFirstWrite: true,
        recorded: .verified
      )
    )
  }

  func testPresentationRegistrationCheck_WhenTheEntryIsWrittenAgain_ThenTakesTheRecordedOutcomeOrKeepsTheStoredOne() {
    XCTAssertEqual(
      WalletKitTransactionLogControllerImpl.presentationRegistrationCheck(
        stored: .notEvaluated,
        isFirstWrite: false,
        recorded: .notBoundToRequester
      ),
      .notBoundToRequester
    )
    XCTAssertEqual(
      WalletKitTransactionLogControllerImpl.presentationRegistrationCheck(stored: .verified, isFirstWrite: false, recorded: nil),
      .verified
    )
  }
}
