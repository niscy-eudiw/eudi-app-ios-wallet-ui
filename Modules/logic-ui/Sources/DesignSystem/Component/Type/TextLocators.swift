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

public enum TextLocators: String, LocatorType {
  case quickPinTitle
  case successTitle
  case addDocumentTitle
  case documentSuccessDescription
  case requestDescription

  public var id: String {
    switch self {
    case .quickPinTitle:
      return "quick_pin_title"
    case .successTitle:
      return "success_title"
    case .addDocumentTitle:
      return "add_document_title"
    case .documentSuccessDescription:
      return "document_success_description"
    case .requestDescription:
      return "request_description"
    }
  }

  public var trait: AccessibilityTraits? {
    .isStaticText
  }
}
