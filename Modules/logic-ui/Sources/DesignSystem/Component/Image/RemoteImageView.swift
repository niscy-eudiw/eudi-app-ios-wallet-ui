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
import SDWebImageSwiftUI

public struct RemoteImageView: View {

  let url: URL?
  let icon: Image?
  let width: Double?
  let height: Double?
  let retryFailed: Bool
  let onSuccess: ((CGSize) -> Void)?
  let onFailure: (() -> Void)?

  private var getWidth: Double {
    guard let width = self.width else { return .infinity }
    return width
  }

  private var getHeight: Double {
    guard let height = self.height else { return .infinity }
    return height
  }

  public init(
    url: URL?,
    icon: Image?,
    width: Double?,
    height: Double?,
    retryFailed: Bool = false,
    onSuccess: ((CGSize) -> Void)? = nil,
    onFailure: (() -> Void)? = nil
  ) {
    self.url = url
    self.icon = icon
    self.width = width
    self.height = height
    self.retryFailed = retryFailed
    self.onSuccess = onSuccess
    self.onFailure = onFailure
  }

  public var body: some View {
    WebImage(
      url: Self.loadableUrl(url),
      options: retryFailed ? [.retryFailed] : [],
      context: Self.loadingContext(for: url)
    ) { image in
      image
        .resizable()
        .scaledToFit()
    } placeholder: {
      if let icon {
        icon
          .resizable()
          .scaledToFit()
      }
    }
    .onSuccess { image, _, _ in
      onSuccess?(image.size)
    }
    .onFailure { _ in
      onFailure?()
    }
    .indicator(.progress)
    .if(url != nil || icon != nil) { view in
      view.frame(
        maxWidth: self.getWidth,
        maxHeight: self.getHeight
      )
    }
  }
}

public extension RemoteImageView {
  enum ImageContentOption {
    case none
    case remoteImage(URL?, Image?)
    case image(Image)

    public var isNone: Bool {
      switch self {
      case .none:
        return true
      default:
        return false
      }
    }
  }
}

public extension RemoteImageView {

  enum Constants {
    /// The largest image the wallet downloads, Android's limit for a logo.
    public static let maxImageByteCount: Int64 = 2 * 1024 * 1024
    /// The decoded size above which an image is scaled down while it is decoded.
    public static let maxDecodedByteCount: UInt = 16 * 1024 * 1024
  }

  /// The image's address if the wallet may load it: `https` with a host only, as on Android, whatever passed it.
  static func loadableUrl(_ url: URL?) -> URL? {
    url?.isHttpsWebLink == true ? url : nil
  }

  /// True for a response to accept: still on the requested origin after any redirect, and not declared larger than
  /// `Constants.maxImageByteCount`; the decode is capped either way.
  static func acceptsResponse(requestedUrl: URL, responseUrl: URL?, expectedContentLength: Int64) -> Bool {
    guard
      let responseUrl,
      responseUrl.isHttpsWebLink,
      responseUrl.host?.lowercased() == requestedUrl.host?.lowercased(),
      (responseUrl.port ?? 443) == (requestedUrl.port ?? 443)
    else {
      return false
    }
    return expectedContentLength <= Constants.maxImageByteCount
  }

  /// Refuses a response off the requested origin or too large, and scales a large image down while decoding it.
  static func loadingContext(for url: URL?) -> [SDWebImageContextOption: Any]? {
    guard let requestedUrl = loadableUrl(url) else { return nil }
    let responseModifier = SDWebImageDownloaderResponseModifier { response in
      acceptsResponse(
        requestedUrl: requestedUrl,
        responseUrl: response.url,
        expectedContentLength: response.expectedContentLength
      ) ? response : nil
    }
    return [
      .downloadResponseModifier: responseModifier,
      .imageScaleDownLimitBytes: Constants.maxDecodedByteCount
    ]
  }
}
