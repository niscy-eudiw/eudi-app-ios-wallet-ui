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

final class TestDeferredIssuancePayload: EudiTest {

  func testUserInfo_WhenReadBack_ThenGivesTheSameDocuments() {
    let payload = DeferredIssuancePayload(issued: ["a": "PID", "b": "PID"], failed: ["c": "mDL"])

    XCTAssertEqual(DeferredIssuancePayload(userInfo: payload.userInfo), payload)
  }

  func testInitUserInfo_WhenItNamesNoDocument_ThenIsNil() {
    let empty = DeferredIssuancePayload(issued: [:], failed: [:])

    XCTAssertNil(DeferredIssuancePayload(userInfo: empty.userInfo))
  }

  func testInitUserInfo_WhenItHasAnotherShape_ThenIsNil() {
    XCTAssertNil(DeferredIssuancePayload(userInfo: nil))
    XCTAssertNil(DeferredIssuancePayload(userInfo: ["issued": ["a"], "failed": [:]]))
    XCTAssertNil(DeferredIssuancePayload(userInfo: ["issued": ["a": "PID"]]))
  }
}
