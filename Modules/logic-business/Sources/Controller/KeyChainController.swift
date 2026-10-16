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
import Security
@preconcurrency import LocalAuthentication
@preconcurrency import KeychainAccess

public protocol KeyChainWrapper {
  var value: String { get }
}

public protocol KeyChainController: Sendable {
  func storeValue(key: KeyChainWrapper, value: String)
  func storeValue(key: KeyChainWrapper, value: Data)
  func getValue(key: KeyChainWrapper) -> String?
  func getData(key: KeyChainWrapper) -> Data?
  /// Reads a string, telling a missing item (`nil`) apart from a failed read, which throws
  /// `KeyChainError.readFailed`.
  func fetchValue(key: KeyChainWrapper) throws -> String?
  /// Reads data, telling a missing item (`nil`) apart from a failed read, which throws
  /// `KeyChainError.readFailed`.
  func fetchData(key: KeyChainWrapper) throws -> Data?
  /// Writes a string; a failed write, which `storeValue` ignores, throws `KeyChainError.writeFailed`.
  func saveValue(key: KeyChainWrapper, value: String) throws
  /// Writes data; a failed write, which `storeValue` ignores, throws `KeyChainError.writeFailed`.
  func saveValue(key: KeyChainWrapper, value: Data) throws
  func removeObject(key: KeyChainWrapper)
  /// Writes the biometric probe, bound to the biometric enrolment of this moment (`.biometryCurrentSet`), when the
  /// user turns biometric unlock on; a probe already there is replaced.
  func storeBiometricProbe() throws
  /// Reads the probe with `context`, which has already evaluated the biometric policy, so the read does not prompt
  /// again. After a new enrolment the probe can no longer be read, as Android's key is invalidated by enrolment; a
  /// missing or unreadable probe throws `KeyChainError.itemNotFound`, and the PIN is needed.
  func validateKeyChainBiometry(with context: LAContext) throws
  func clearKeyChainBiometry()
  @discardableResult func clear() -> Bool
}

final class KeyChainControllerImpl: KeyChainController {

  private let biometryKey = "eu.europa.ec.euidi.biometric.access"
  private let configLogic: ConfigLogic
  private let keyChain: Keychain

  public init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    let service = configLogic.keyChainConfig.documentStorageServiceName
    keyChain = Keychain(
      service: service,
      accessGroup: accessGroup
    )
    .accessibility(Self.accessibility)
    Self.moveItemsFromThePreviousClass(service: service, accessGroup: accessGroup)
  }

  public func storeValue(key: KeyChainWrapper, value: String) {
    keyChain[key.value] = value
  }

  public func storeValue(key: KeyChainWrapper, value: Data) {
    keyChain[data: key.value] = value
  }

  public func getValue(key: KeyChainWrapper) -> String? {
    keyChain[key.value]
  }

  func getData(key: KeyChainWrapper) -> Data? {
    try? keyChain.getData(key.value)
  }

  public func fetchValue(key: KeyChainWrapper) throws -> String? {
    do {
      return try keyChain.getString(key.value)
    } catch {
      throw KeyChainError.readFailed(status: keyChainStatus(of: error))
    }
  }

  public func fetchData(key: KeyChainWrapper) throws -> Data? {
    do {
      return try keyChain.getData(key.value)
    } catch {
      throw KeyChainError.readFailed(status: keyChainStatus(of: error))
    }
  }

  public func saveValue(key: KeyChainWrapper, value: String) throws {
    do {
      try keyChain.set(value, key: key.value)
    } catch {
      throw KeyChainError.writeFailed(status: keyChainStatus(of: error))
    }
  }

  public func saveValue(key: KeyChainWrapper, value: Data) throws {
    do {
      try keyChain.set(value, key: key.value)
    } catch {
      throw KeyChainError.writeFailed(status: keyChainStatus(of: error))
    }
  }

  public func removeObject(key: KeyChainWrapper) {
    try? keyChain.remove(key.value)
  }

  public func storeBiometricProbe() throws {
    clearKeyChainBiometry()
    try setBiometricKey(value: UUID().uuidString)
  }

  public func validateKeyChainBiometry(with context: LAContext) throws {
    let item = try self.keyChain
      .authenticationContext(context)
      .get(self.biometryKey)
    try Self.validateBiometricItem(item)
  }

  public func clearKeyChainBiometry() {
    try? self.keyChain.remove(self.biometryKey)
  }

  /// Removes the app's keychain service, every generic-password item in the wallet's access group (document
  /// storage included) and every key item there, such as WalletKit's DPoP keys, so that no key an issuer has seen
  /// outlives a reset or a reinstall.
  @discardableResult
  public func clear() -> Bool {
    try? keyChain.removeAll()
    let isDocumentStorageCleared = clearDocumentStorage()
    return clearKeys() && isDocumentStorageCleared
  }
}

private extension KeyChainControllerImpl {
  /// The keychain status a KeychainAccess error carries, or `errSecInternalError` for any other error.
  func keyChainStatus(of error: Error) -> OSStatus {
    (error as? Status)?.rawValue ?? errSecInternalError
  }

  func clearKeys() -> Bool {
    var query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecUseDataProtectionKeychain as String: true
    ]
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
  }

  func clearDocumentStorage() -> Bool {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecUseDataProtectionKeychain as String: true
    ]
    let accessGroup = configLogic.keyChainConfig.keychainAccessGroup
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess || status == errSecItemNotFound
  }

  func setBiometricKey(value: String) throws {
    try self.keyChain
      .accessibility(
        .whenPasscodeSetThisDeviceOnly,
        authenticationPolicy: [.biometryCurrentSet]
      )
      .set(value, key: self.biometryKey)
  }

}

extension KeyChainControllerImpl {

  /// The class of every item this controller writes, except the biometric probe: readable only while the device is
  /// unlocked, and never part of a backup, so the PIN salt and verifier cannot be restored to another device.
  static var accessibility: Accessibility { .whenUnlockedThisDeviceOnly }

  /// The items of `service` that a build before `accessibility` wrote as `.whenUnlocked`.
  static func previousClassQuery(service: String, accessGroup: String) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
    ]
    if !accessGroup.isEmpty {
      query[kSecAttrAccessGroup as String] = accessGroup
    }
    return query
  }

  /// The update that moves those items to `accessibility`.
  static func thisDeviceOnlyAttributes() -> [String: Any] {
    [kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
  }

  /// Moves the items an earlier build wrote as `.whenUnlocked` to `accessibility`. It runs on every start and finds
  /// nothing once they have moved; while the device is locked they cannot be moved, and a later start moves them.
  /// wallet-storage's items are written as `.whenPasscodeSetThisDeviceOnly` and are not touched.
  static func moveItemsFromThePreviousClass(service: String, accessGroup: String) {
    SecItemUpdate(
      previousClassQuery(service: service, accessGroup: accessGroup) as CFDictionary,
      thisDeviceOnlyAttributes() as CFDictionary
    )
  }

  /// Accepts the biometric probe only when the keychain returned it; a missing item fails. Internal so that unit
  /// tests can check the rule without a biometry-protected item.
  static func validateBiometricItem(_ item: String?) throws {
    guard let item, !item.isEmpty else {
      throw KeyChainError.itemNotFound
    }
  }
}
