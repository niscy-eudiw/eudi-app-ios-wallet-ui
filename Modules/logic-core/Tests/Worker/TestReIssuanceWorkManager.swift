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
@testable import logic_core
@testable import logic_test

final class TestReIssuanceWorkManager: EudiTest {

  var walletKitController: MockWalletKitController!
  var walletKitConfig: MockWalletKitConfig!
  var workManager: ReIssuanceWorkManagerImpl!

  override func setUp() {
    walletKitController = MockWalletKitController()
    walletKitConfig = MockWalletKitConfig()
    stub(walletKitConfig) { mock in
      when(mock.documentIssuanceConfig.get).thenReturn(
        DocumentIssuanceConfig(
          defaultCredentialOptions: CredentialOptions(credentialPolicy: .rotateUse, batchSize: 1),
          documentSpecificCredentialOptions: [:],
          reIssuanceBackgroundRule: ReIssuanceBackgroundRule(backgroundIntervalSeconds: 300)
        )
      )
    }
    workManager = ReIssuanceWorkManagerImpl(
      configLogic: walletKitConfig,
      walletKitController: walletKitController
    )
    stub(walletKitController) { mock in
      when(mock.getDocumentCredentialOptions(with: any())).thenReturn(nil)
      when(mock.reIssueDocument(identifier: any(), isBackgroundOperation: any())).thenThrow(RuntimeError.genericError)
      when(mock.removeAllFailedReIssuedDocuments()).thenDoNothing()
      when(mock.storeFailedReIssuedDocuments(ids: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    walletKitController = nil
    walletKitConfig = nil
    workManager = nil
  }

  func testCheckReIssuance_WhenDocumentsAreRevokedSuspendedOrUnrecognised_ThenOnlyTheOthersAreReIssued() async throws {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .revoked, "b": .suspended, "c": .unrecognised])
      when(mock.fetchIssuedDocuments()).thenReturn(["a", "b", "c", "d"].map { FixtureDocument.make(id: $0) })
    }

    try await workManager.checkReIssuance()

    verify(walletKitController).reIssueDocument(identifier: equal(to: "d"), isBackgroundOperation: equal(to: true))
    for id in ["a", "b", "c"] {
      verify(walletKitController, never()).reIssueDocument(identifier: equal(to: id), isBackgroundOperation: any())
    }
  }

  func testCheckReIssuance_WhenNothingIsDue_ThenTheOldFailureRecordsAreCleared() async throws {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenReturn(["a": .revoked])
      when(mock.fetchIssuedDocuments()).thenReturn([FixtureDocument.make(id: "a")])
    }

    try await workManager.checkReIssuance()

    verify(walletKitController).removeAllFailedReIssuedDocuments()
    verify(walletKitController, never()).reIssueDocument(identifier: any(), isBackgroundOperation: any())
  }

  func testCheckReIssuance_WhenTheRevocationRecordsCannotBeRead_ThenReIssuesNothing() async {
    stub(walletKitController) { mock in
      when(mock.fetchRevokedDocumentStatuses()).thenThrow(RuntimeError.genericError)
      when(mock.fetchIssuedDocuments()).thenReturn([FixtureDocument.make(id: "d")])
    }

    do {
      try await workManager.checkReIssuance()
      XCTFail("Expected the round to stop")
    } catch {
      verify(walletKitController, never()).reIssueDocument(identifier: any(), isBackgroundOperation: any())
    }
  }
}
