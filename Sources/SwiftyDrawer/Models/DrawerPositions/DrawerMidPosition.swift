import UIKit

public enum DrawerMidPosition: Equatable {
    case absolute(Double)
    case relativeToSafeAreaBottom(offset: Double)
    case relativeToTabBar(offset: Double)
}
