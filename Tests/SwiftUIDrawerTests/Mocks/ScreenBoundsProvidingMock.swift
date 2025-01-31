import Foundation
@testable import SwiftUIDrawer

class ScreenBoundsProvidingMock: ScreenBoundsProviding {
    static let width = 1080.0
    static let height = 1920.0
    
    var bounds: CGRect = .init(
        x: 0,
        y: 0,
        width: width,
        height: height
    )
}
