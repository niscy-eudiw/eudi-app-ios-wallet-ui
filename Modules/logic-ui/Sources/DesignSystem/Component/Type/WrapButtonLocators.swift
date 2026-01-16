/*
 * Copyright (c) 2025 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import logic_resources

public enum WrapButtonLocators: String, LocatorType {
  case scanQrCode
  case errorRetryButton
  case deleteDocument
  case confirmDialogDeleteButton
  case confirmDialogCancelButton
  case authenticateAuthoriseTransactions
  case electronicallySignDigitalDocuments
  case showResults
  case genericSuccessButton
  case transactionDetailsRequestDeletionButton
  case transactionDetailsReportTransactionButton
  case updateNowButton

  public var id: String {
    switch self {
    case .scanQrCode:
      return "scan_qr_code_button"
    case .errorRetryButton:
      return "error_retry_button"
    case .deleteDocument:
      return "delete_document_button"
    case .confirmDialogDeleteButton:
      return "confirm_dialog_delete_button"
    case .confirmDialogCancelButton:
      return "confirm_dialog_cancel_button"
    case .authenticateAuthoriseTransactions:
      return "authenticate_authorise_transactions"
    case .electronicallySignDigitalDocuments:
      return "electronically_sign_digital_documents"
    case .showResults:
      return "show_results"
    case .genericSuccessButton:
      return "success_button"
    case .transactionDetailsRequestDeletionButton:
      return "transaction_details_request_deletion_button"
    case .transactionDetailsReportTransactionButton:
      return "transaction_details_report_transaction_button"
    case .updateNowButton:
      return "update_now_button"
    }
  }

  public var trait: AccessibilityTraits? {
    .isButton
  }
}
