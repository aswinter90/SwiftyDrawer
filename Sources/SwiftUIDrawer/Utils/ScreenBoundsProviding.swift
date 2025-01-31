import UIKit

public protocol ScreenBoundsProviding {
    var bounds: CGRect { get }
}

extension UIScreen: ScreenBoundsProviding {}
