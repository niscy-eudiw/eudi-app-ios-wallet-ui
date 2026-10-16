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
import logic_storage
import Foundation

final actor WalletKitTransactionLogControllerImpl: TransactionLogger {

  private let transactionLogStorageController: any TransactionLogStorageController
  private let registrationCheckRecorder: RegistrationCheckRecorder

  init(
    transactionLogStorageController: any TransactionLogStorageController,
    registrationCheckRecorder: RegistrationCheckRecorder
  ) {
    self.transactionLogStorageController = transactionLogStorageController
    self.registrationCheckRecorder = registrationCheckRecorder
  }

  /// A presentation's entry keeps the registration outcome recorded while it was shown (`RegistrationCheckRecorder`).
  func log(transaction: TransactionEntry) async throws {
    let stored = try? await transactionLogStorageController.retrieve(transaction.transactionIdentifier)
    var registrationCheck = stored?.registrationCheck.flatMap { RecordedRegistrationCheck(rawValue: $0) }
    if case .presentation = transaction, let recorded = await registrationCheckRecorder.take() {
      registrationCheck = recorded
    }
    try await transactionLogStorageController.store(
      transaction.toTransactionLogStorage(
        parentPresentationId: stored?.parentPresentationId,
        actionChannel: stored?.actionChannel.flatMap { TransactionActionChannel(rawValue: $0) },
        registrationCheck: registrationCheck
      )
    )
  }
}
