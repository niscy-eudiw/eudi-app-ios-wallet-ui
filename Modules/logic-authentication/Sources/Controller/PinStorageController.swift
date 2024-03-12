/*
 * Copyright (c) 2023 European Commission
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

public protocol PinStorageControllerType {
  func retrievePin() -> String?
  func setPin(with pin: String)
  func isPinValid(with pin: String) -> Bool
}

public class PinStorageController: PinStorageControllerType {

  public static let shared: PinStorageControllerType = PinStorageController()

  private lazy var config: PinStorageConfig = PinStorageConfigProvider.shared.getConfig()

  public func retrievePin() -> String? {
    config.storageProvider.retrievePin()
  }

  public func setPin(with pin: String) {
    config.storageProvider.setPin(with: pin)
  }

  public func isPinValid(with pin: String) -> Bool {
    config.storageProvider.isPinValid(with: pin)
  }
}