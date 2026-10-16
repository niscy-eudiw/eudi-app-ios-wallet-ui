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
import XCTest
import UIKit
@testable import logic_core
@testable import logic_test

final class TestImageDecodeLimits: EudiTest {

  func testIsWithinLimit_WhenTheImageHasMoreThanFortyMegapixels_ThenIsNotDecoded() {
    XCTAssertFalse(ImageDecodeLimits.isWithinLimit(width: 8_000, height: 6_000))
    XCTAssertFalse(ImageDecodeLimits.isWithinLimit(width: 0, height: 10))
    XCTAssertTrue(ImageDecodeLimits.isWithinLimit(width: 4_000, height: 3_000))
  }

  func testDecode_WhenASideIsLargerThanTheLimit_ThenScalesItDown() throws {
    let data = try XCTUnwrap(pngData(width: 4_096, height: 16))

    let image = try XCTUnwrap(ImageDecodeLimits.decode(data))

    XCTAssertLessThanOrEqual(Int(image.size.width * image.scale), ImageDecodeLimits.maxDimension)
  }

  func testDecode_WhenTheDataIsNotAnImage_ThenDecodesNothing() {
    XCTAssertNil(ImageDecodeLimits.decode(Data([0x00, 0x01, 0x02])))
  }
}

private extension TestImageDecodeLimits {

  func pngData(width: Int, height: Int) -> Data? {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    return UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format).pngData { context in
      UIColor.gray.setFill()
      context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    }
  }
}
