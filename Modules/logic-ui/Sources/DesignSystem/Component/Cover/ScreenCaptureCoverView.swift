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
import SwiftUI
import logic_resources

/// What the wallet shows instead of its screens: the background alone in the app switcher, and a message while the
/// screen is recorded, mirrored or shared.
struct ScreenCaptureCoverView: View {

  let isMessageShown: Bool

  var body: some View {
    ZStack {
      Theme.shared.color.background
      if isMessageShown {
        Text(.screenCaptureCoverMessage)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .multilineTextAlignment(.center)
          .padding(Theme.shared.dimension.padding)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
  }
}

#Preview {
  ScreenCaptureCoverView(isMessageShown: true)
}
