import UIKit
@testable import SwiftyDrawer

final class TabBarFrameProvidingMock: TabBarFrameProviding {
    static let width = 1080.0
    static let height = 80.0

    let frame: CGRect = .init(
        x: 0.0,
        y: 0.0,
        width: width,
        height: height
    )
}
