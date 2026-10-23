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

final class TestSessionCoordinatorHolder: EudiTest {

  func testGetActiveRemoteCoordinator_WhenNoneIsSet_ThenThrowsNoActiveSession() async {
    let holder = SessionCoordinatorHolderImpl()

    var thrown: Error?
    do {
      _ = try await holder.getActiveRemoteCoordinator()
    } catch {
      thrown = error
    }

    XCTAssertEqual(thrown as? PresentationSessionError, .noActiveSession)
  }

  func testGetActiveProximityCoordinator_WhenNoneIsSet_ThenThrowsNoActiveSession() async {
    let holder = SessionCoordinatorHolderImpl()

    var thrown: Error?
    do {
      _ = try await holder.getActiveProximityCoordinator()
    } catch {
      thrown = error
    }

    XCTAssertEqual(thrown as? PresentationSessionError, .noActiveSession)
  }
}
