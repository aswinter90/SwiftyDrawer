import UIKit

public enum DrawerMidPosition: Equatable, Sendable {
    case absolute(Double)
    case relativeToSafeAreaBottom(offset: Double)
}
