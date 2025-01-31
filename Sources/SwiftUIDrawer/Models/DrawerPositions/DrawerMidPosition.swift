import UIKit

public enum DrawerMidPosition: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(offset: CGFloat)
    case relativeToTabBar(offset: CGFloat)
}
