/*
 * Copyright (c) 2023 European Commission
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
import SwiftUI

public protocol ColorManagerProtocol {

  var black: Color { get }
  var white: Color { get }
  var blue: Color { get }
  var red: Color { get }
  var grey: Color { get }
  var darkGrey: Color { get }

  var backgroundDefault: Color { get }
  var backgroundPaper: Color { get }
  var chipBackground: Color { get }
  var infoBackground: Color { get }
  var dividerDark: Color { get }
  var lightGradientEnd: Color { get }
  var lightGradientStart: Color { get }
  var error: Color { get }
  var primaryDark: Color { get }
  var primaryLight: Color { get }
  var primary: Color { get }
  var success: Color { get }
  var secondary: Color { get }
  var textDisabledDark: Color { get }
  var textDisabledLight: Color { get }
  var textPrimaryDark: Color { get }
  var textSecondaryDark: Color { get }
  var textSecondaryLight: Color { get }

  var material: MaterialColor { get }
}

final class ColorManager: ColorManagerProtocol {

  // MARK: - Properties

  enum PaletteColorEnum: String {
    case backgroundDefault
    case backgroundPaper
    case chipBackground
    case infoBackground

    case dividerDark
    case lightGradientEnd
    case lightGradientStart

    case errorMain
    case primaryDark
    case primaryLight
    case primaryMain
    case successText
    case secondaryMain

    case textDisabledDark
    case textDisabledLight
    case textPrimaryDark
    case textSecondaryDark
    case textSecondaryLight
  }

  enum BaseColors: String {
    case black
    case white
    case blue
    case red
    case grey
    case darkGrey
  }

  public var black: Color {
    Color(BaseColors.black.rawValue, bundle: bundle)
  }
  public var white: Color {
    Color(BaseColors.white.rawValue, bundle: bundle)
  }
  public var blue: Color {
    Color(BaseColors.blue.rawValue, bundle: bundle)
  }
  public var red: Color {
    Color(BaseColors.red.rawValue, bundle: bundle)
  }
  public var grey: Color {
    Color(BaseColors.grey.rawValue, bundle: bundle)
  }
  public var darkGrey: Color {
    Color(BaseColors.darkGrey.rawValue, bundle: bundle)
  }
  public var backgroundDefault: Color {
    Color(PaletteColorEnum.backgroundDefault.rawValue, bundle: bundle)
  }
  public var backgroundPaper: Color {
    Color(PaletteColorEnum.backgroundPaper.rawValue, bundle: bundle)
  }
  public var chipBackground: Color {
    Color(PaletteColorEnum.chipBackground.rawValue, bundle: bundle)
  }
  var infoBackground: Color {
    Color(PaletteColorEnum.infoBackground.rawValue, bundle: bundle)
  }
  public var dividerDark: Color {
    Color(PaletteColorEnum.dividerDark.rawValue, bundle: bundle)
  }
  public var lightGradientEnd: Color {
    Color(PaletteColorEnum.lightGradientEnd.rawValue, bundle: bundle)
  }
  public var lightGradientStart: Color {
    Color(PaletteColorEnum.lightGradientStart.rawValue, bundle: bundle)
  }
  public var error: Color {
    Color(PaletteColorEnum.errorMain.rawValue, bundle: bundle)
  }
  public var primaryDark: Color {
    Color(PaletteColorEnum.primaryDark.rawValue, bundle: bundle)
  }
  public var primaryLight: Color {
    Color(PaletteColorEnum.primaryLight.rawValue, bundle: bundle)
  }
  public var primary: Color {
    Color(PaletteColorEnum.primaryMain.rawValue, bundle: bundle)
  }
  public var success: Color {
    Color(PaletteColorEnum.successText.rawValue, bundle: bundle)
  }
  public var secondary: Color {
    Color(PaletteColorEnum.secondaryMain.rawValue, bundle: bundle)
  }
  public var textDisabledDark: Color {
    Color(PaletteColorEnum.textDisabledDark.rawValue, bundle: bundle)
  }
  public var textDisabledLight: Color {
    Color(PaletteColorEnum.textDisabledLight.rawValue, bundle: bundle)
  }
  public var textPrimaryDark: Color {
    Color(PaletteColorEnum.textPrimaryDark.rawValue, bundle: bundle)
  }
  public var textSecondaryDark: Color {
    Color(PaletteColorEnum.textSecondaryDark.rawValue, bundle: bundle)
  }
  public var textSecondaryLight: Color {
    Color(PaletteColorEnum.textSecondaryLight.rawValue, bundle: bundle)
  }

  var bundle: Bundle

  var material: MaterialColor

  // MARK: - Lifecycle

  init(bundle: Bundle) {
    material = MaterialColor(bundle: bundle)
    self.bundle = bundle
  }

}