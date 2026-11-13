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
import EudiWalletKit
import enum OpenID4VCI.CredentialIssuanceError
import enum OpenID4VCI.CredentialError
import enum OpenID4VCI.PostError
@testable import logic_core
@testable import logic_test

final class TestDeferredRequestFailure: EudiTest {

  func testInit_WhenTheIssuerRejectsTheTransactionOrTheCredential_ThenItIsARefusal() {
    let errors: [CredentialIssuanceError] = [
      .invalidTransactionId,
      .unsupportedCredentialType,
      .unsupportedCredentialFormat,
      .invalidProof(errorDescription: nil),
      .invalidEncryptionParameters
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .refused, "\(error)")
    }
  }

  func testInit_WhenTheIssuerAnswersAClientError_ThenItIsARefusal() {
    for statusCode in [400, 401, 403, 404] {
      let error = CredentialIssuanceError.requestFailed(
        code: statusCode,
        error: "credential_request_denied",
        errorDescription: nil
      )
      XCTAssertEqual(DeferredRequestFailure(error), .refused, "\(statusCode)")
    }
  }

  func testInit_WhenTheIssuerAsksToWaitOrSlowDown_ThenItIsTransient() {
    for statusCode in [408, 429] {
      let error = CredentialIssuanceError.requestFailed(code: statusCode, error: "slow_down", errorDescription: nil)
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(statusCode)")
    }
  }

  func testInit_WhenTheAccessTokenIsRejected_ThenItIsTransient() {
    XCTAssertEqual(DeferredRequestFailure(CredentialIssuanceError.invalidToken), .transient)
  }

  func testInit_WhenTheConnectionOrTheServerFails_ThenItIsTransient() {
    let errors: [Error] = [
      URLError(.notConnectedToInternet),
      URLError(.timedOut),
      PostError.networkError(URLError(.networkConnectionLost)),
      PostError.invalidStatusCode(nil, 503, nil),
      PostError.requestError(404, URLError(.cannotParseResponse))
    ]
    for error in errors {
      XCTAssertEqual(DeferredRequestFailure(error), .transient, "\(error)")
    }
  }

  func testInit_WhenTheIssuerDoesNotSupportDeferredIssuance_ThenItIsARefusal() {
    XCTAssertEqual(DeferredRequestFailure(CredentialError.issuerDoesNotSupportDeferredIssuance), .refused)
  }

  func testInit_WhenWalletKitRefusesTheCredentialOrCannotCompleteTheDocument_ThenItIsARefusal() {
    let codes: [WalletError.Code] = [
      .issuanceRequestFailed,
      .trustError,
      .internalError,
      .unsupportedCredentialConfiguration,
      .missingVciConfiguration
    ]
    for code in codes {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .refused, "\(code)")
    }
  }

  func testInit_WhenWalletKitFailsOtherwise_ThenItIsTransient() {
    for code: WalletError.Code in [.storageError, .issuerMetadataResolutionFailed, .statusCheckFailed] {
      XCTAssertEqual(DeferredRequestFailure(WalletError(description: "", code: code)), .transient, "\(code)")
    }
  }

  func testInit_WhenWalletKitWrapsAnotherError_ThenTheWrappedErrorDecides() {
    let wrappedConnectionLoss = WalletError(
      description: "",
      code: .issuanceRequestFailed,
      innerError: URLError(.networkConnectionLost)
    )
    let wrappedRefusal = WalletError(
      description: "",
      code: .storageError,
      innerError: CredentialIssuanceError.invalidTransactionId
    )

    XCTAssertEqual(DeferredRequestFailure(wrappedConnectionLoss), .transient)
    XCTAssertEqual(DeferredRequestFailure(wrappedRefusal), .refused)
  }

  func testInit_WhenTheDocumentHasNoMetadata_ThenItIsARefusal() {
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.missingMetadata), .refused)
  }

  func testInit_WhenTheErrorIsUnknown_ThenItIsTransient() {
    XCTAssertEqual(DeferredRequestFailure(WalletCoreError.unableFetchDocument), .transient)
    XCTAssertEqual(DeferredRequestFailure(NSError(domain: "test", code: 1)), .transient)
  }
}
