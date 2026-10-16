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

/// The issuer a credential offer link comes from, read from the link alone before anything is fetched, so that the
/// wallet contacts no host other than a configured issuer's and never gives one issuer's client settings to another;
/// as the Android wallet's `offerIssuerOf`.
public enum OfferIssuer: Equatable, Sendable {
  case configured(String)
  case notConfigured
  /// The link carries no offer, or carries it more than once.
  case unreadable

  /// An offer passed by value (`credential_offer`) must name one of `configuredIssuers` as its `credential_issuer`,
  /// compared exactly. An offer passed by reference (`credential_offer_uri`) is fetched from that address, so the
  /// address must be `https` on the origin of a configured issuer, which is then returned.
  public static func of(offerUri: String, configuredIssuers: [String]) -> OfferIssuer {
    let offerParameters = (URLComponents(string: offerUri)?.queryItems ?? []).filter {
      ["credential_offer", "credential_offer_uri"].contains($0.name.lowercased())
    }
    guard offerParameters.count == 1, let parameter = offerParameters.first, let value = parameter.value else {
      return .unreadable
    }
    if parameter.name.lowercased() == "credential_offer" {
      guard
        let data = value.data(using: .utf8),
        let offer = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let issuer = offer["credential_issuer"] as? String
      else {
        return .unreadable
      }
      return configuredIssuers.contains(issuer) ? .configured(issuer) : .notConfigured
    }
    guard let reference = URLComponents(string: value), reference.isHttpsWithHost else {
      return .notConfigured
    }
    let issuer = configuredIssuers.first { issuer in
      URLComponents(string: issuer).map { $0.isHttpsWithHost && $0.hasSameOrigin(as: reference) } ?? false
    }
    return issuer.map(OfferIssuer.configured) ?? .notConfigured
  }
}

private extension URLComponents {

  var isHttpsWithHost: Bool {
    scheme?.lowercased() == "https" && !(host ?? "").isEmpty
  }

  func hasSameOrigin(as other: URLComponents) -> Bool {
    host?.lowercased() == other.host?.lowercased() && (port ?? 443) == (other.port ?? 443)
  }
}
