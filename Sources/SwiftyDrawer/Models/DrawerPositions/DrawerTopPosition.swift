import UIKit

public enum DrawerTopPosition: Equatable, Sendable {
    case absolute(Double)
    case relativeToSafeAreaTop(offset: Double)
}
