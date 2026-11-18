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
import Foundation
import EudiWalletKit
import enum OpenID4VCI.CredentialIssuanceError
import enum OpenID4VCI.CredentialError
import enum OpenID4VCI.PostError
import enum OpenID4VCI.FetchError

/// Classifies a failed deferred request. Only explicit issuer errors (e.g. invalid_transaction_id) and
/// documents we can no longer complete are permanent; everything else is retried with backoff.
/// `issuance_pending` never ends up here: OpenID4VCI maps it to a pending response.
enum DeferredRequestFailure: Equatable {

  /// The issuer won't issue the credential. Stop asking; the user can delete the document.
  case refused
  /// Might succeed later. Retry with backoff, up to `maxConsecutiveFailedAttempts`.
  case transient
  /// The device has no network or can't resolve the issuer's name, as the Android wallet's
  /// `isOfflineFailure`. Retried like a transient failure but not counted. Other network errors, such
  /// as a timeout or a lost connection, are transient.
  case offline

  init(_ error: Error) {
    self = Self.classify(error)
  }
}

private extension DeferredRequestFailure {

  static func classify(_ error: Error) -> DeferredRequestFailure {
    if isOffline(error) {
      return .offline
    }
    switch error {
    case let error as CredentialIssuanceError:
      return classify(error)
    case let error as WalletError:
      return classify(error)
    case CredentialError.issuerDoesNotSupportDeferredIssuance:
      return .refused
    case WalletCoreError.missingMetadata:
      return .refused
    default:
      return .transient
    }
  }

  // A 4xx without an OpenID4VCI error body arrives as PostError, not here, and stays transient:
  // it may come from a proxy or gateway rather than the issuer.
  static func classify(_ error: CredentialIssuanceError) -> DeferredRequestFailure {
    switch error {
    case .invalidTransactionId,
        .unsupportedCredentialType,
        .unsupportedCredentialFormat,
        .invalidProof,
        .invalidEncryptionParameters:
      return .refused
    case .requestFailed(let statusCode, _, _):
      return isRefusal(statusCode: statusCode) ? .refused : .transient
    default:
      return .transient
    }
  }

  // WalletKit may wrap the underlying error; if so, classify that one instead.
  static func classify(_ error: WalletError) -> DeferredRequestFailure {
    if let innerError = error.innerError {
      return classify(innerError)
    }
    // issuanceRequestFailed on its own is an answer WalletKit couldn't read: a 2xx body without a credential
    // or an interval, or a credential that fails its checks. Asking again settles it, since a transaction_id
    // that was already used comes back as invalid_transaction_id.
    switch error.code {
    case .trustError,
        .internalError,
        .unsupportedCredentialConfiguration,
        .missingVciConfiguration:
      return .refused
    default:
      return .transient
    }
  }

  static let offlineCodes: Set<Int> = [
    NSURLErrorNotConnectedToInternet,
    NSURLErrorDataNotAllowed,
    NSURLErrorCannotFindHost,
    NSURLErrorDNSLookupFailed
  ]

  // OpenID4VCI wraps URLSession errors in PostError or FetchError, and WalletKit may wrap them again.
  static func isOffline(_ error: Error, depth: Int = 0) -> Bool {
    guard depth < 8 else { return false }
    let inner: Error?
    switch error {
    case let error as WalletError:
      inner = error.innerError
    case PostError.networkError(let error):
      inner = error
    case FetchError.networkError(let error):
      inner = error
    default:
      let error = error as NSError
      if error.domain == NSURLErrorDomain, offlineCodes.contains(error.code) {
        return true
      }
      inner = error.userInfo[NSUnderlyingErrorKey] as? Error
    }
    guard let inner else { return false }
    return isOffline(inner, depth: depth + 1)
  }

  // 4xx except 408 and 429. WalletKit has already retried once with a refreshed access token.
  static func isRefusal(statusCode: Int) -> Bool {
    (400..<500).contains(statusCode) && ![408, 429].contains(statusCode)
  }
}
