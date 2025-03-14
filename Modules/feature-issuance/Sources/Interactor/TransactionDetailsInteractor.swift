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
import Foundation
import logic_ui
import logic_resources
import feature_common
import logic_business
import logic_core

public struct TransactionClaimItem {
  private let transactionId: String
  private let elementIdentifier: String
  private let value: String
  private let readableName: String
  private let isAvailable: Bool

  init(
    transactionId: String,
    elementIdentifier: String = "randomId",
    value: String = "testValue",
    readableName: String = "test_readable_name",
    isAvailable: Bool = true
  ) {
    self.transactionId = transactionId
    self.elementIdentifier = elementIdentifier
    self.value = value
    self.readableName = readableName
    self.isAvailable = isAvailable
  }
}

public struct TransactionDetailsDomain {
  private let transactionName: String
  private let transactionId: String
  private let transactionIdentifier: String?
  private let sharedDataClaimItems: [TransactionClaimItem]
  private let signedDataClaimItems: [TransactionClaimItem]

  public init(
    transactionName: String,
    transactionId: String = "id",
    transactionIdentifier: String? = nil,
    sharedDataClaimItems: [TransactionClaimItem],
    signedDataClaimItems: [TransactionClaimItem]
  ) {
    self.transactionName = transactionName
    self.transactionId = transactionId
    self.transactionIdentifier = transactionIdentifier
    self.sharedDataClaimItems = sharedDataClaimItems
    self.signedDataClaimItems = signedDataClaimItems
  }
}

public enum TransactionDetailsInteractorPartialState {
  case success(
    detailsTitle: String,
    transactionDetailsDomain: TransactionDetailsDomain
  )
  case failure(error: String)
}

public protocol TransactionDetailsInteractor {
  func getTransactionDetails(transactionId: String) -> TransactionDetailsInteractorPartialState
}

final class TransactionDetailsInteractorImpl: TransactionDetailsInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  func getTransactionDetails(transactionId: String) -> TransactionDetailsInteractorPartialState {
    let detailsTitle = "transaction_details_screen_title"
    let transactionDetailsDomain = TransactionDetailsDomain(
      transactionName: "A transaction name",
      transactionId: "randomId",
      sharedDataClaimItems: [
        TransactionClaimItem(
          transactionId: "0",
          value: "John",
          readableName: "given_name"
        ),
        TransactionClaimItem(
          transactionId: "1",
          value: "Doe",
          readableName: "family_name"
        )
      ],
      signedDataClaimItems: [
        TransactionClaimItem(
          transactionId: "0",
          value: "John",
          readableName: "given_name"
        ),
        TransactionClaimItem(
          transactionId: "1",
          value: "Doe",
          readableName: "family_name"
        )
      ]
    )

    let state = TransactionDetailsInteractorPartialState.success(
      detailsTitle: detailsTitle,
      transactionDetailsDomain: transactionDetailsDomain
    )

    return state
  }
}
