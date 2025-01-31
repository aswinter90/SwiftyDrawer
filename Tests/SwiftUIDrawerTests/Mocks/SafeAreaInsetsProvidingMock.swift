import UIKit
@testable import SwiftUIDrawer

class SafeAreaInsetsProvidingMock: SafeAreaInsetsProviding {
    static let topInset = 50.0
    static let bottomInset = 100.0
    
    var insets: UIEdgeInsets = .init(
        top: topInset,
        left: 0,
        bottom: bottomInset,
        right: 0
    )
}
