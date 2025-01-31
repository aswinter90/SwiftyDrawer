import UIKit

public enum DrawerTopPosition: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaTop(offset: CGFloat)
}
