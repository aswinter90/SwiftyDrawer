import UIKit

public enum DrawerTopPosition: Equatable {
    case absolute(Double)
    case relativeToSafeAreaTop(offset: Double)
}
