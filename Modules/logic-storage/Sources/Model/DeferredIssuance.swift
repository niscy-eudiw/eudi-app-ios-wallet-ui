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
import SwiftData

@Model
final class SDDeferredIssuance: IdentifiableObject {

  @Attribute(.unique) var identifier: String
  var nextAttemptAt: Date
  var interval: TimeInterval?
  var failedAttempts: Int
  // DeferredIssuance.State raw value
  var state: String

  init(
    identifier: String,
    nextAttemptAt: Date,
    interval: TimeInterval?,
    failedAttempts: Int,
    state: String
  ) {
    self.identifier = identifier
    self.nextAttemptAt = nextAttemptAt
    self.interval = interval
    self.failedAttempts = failedAttempts
    self.state = state
  }
}

/// When to request the credential of a deferred document again. Keyed by document id.
public struct DeferredIssuance: Sendable, Equatable {

  public enum State: String, Sendable {
    case pending
    /// Refused by the issuer. Not requested again; the user can delete the document.
    case failed
  }

  public let identifier: String
  public let nextAttemptAt: Date
  /// Last interval sent by the issuer, in seconds.
  public let interval: TimeInterval?
  /// Consecutive transient failures, used for the backoff.
  public let failedAttempts: Int
  public let state: State

  public init(
    identifier: String,
    nextAttemptAt: Date,
    interval: TimeInterval? = nil,
    failedAttempts: Int = 0,
    state: State = .pending
  ) {
    self.identifier = identifier
    self.nextAttemptAt = nextAttemptAt
    self.interval = interval
    self.failedAttempts = failedAttempts
    self.state = state
  }
}

extension SDDeferredIssuance {
  // An unknown state (e.g. written by a newer version) falls back to pending.
  func toDeferredIssuance() -> DeferredIssuance {
    DeferredIssuance(
      identifier: identifier,
      nextAttemptAt: nextAttemptAt,
      interval: interval,
      failedAttempts: failedAttempts,
      state: DeferredIssuance.State(rawValue: state) ?? .pending
    )
  }
}

extension DeferredIssuance {
  func toSdModel() -> SDDeferredIssuance {
    SDDeferredIssuance(
      identifier: identifier,
      nextAttemptAt: nextAttemptAt,
      interval: interval,
      failedAttempts: failedAttempts,
      state: state.rawValue
    )
  }
}

extension Array where Element == DeferredIssuance {
  func toSdModels() -> [SDDeferredIssuance] {
    map { $0.toSdModel() }
  }
}
