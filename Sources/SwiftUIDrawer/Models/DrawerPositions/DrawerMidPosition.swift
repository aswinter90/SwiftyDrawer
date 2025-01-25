import UIKit

public enum DrawerMidPosition: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(offset: CGFloat)
    case relativeToTabBar(offset: CGFloat)
    
    mutating func updateAssociatedValueOfCurrentCase(_ newValue: CGFloat) {
        switch self {
        case .absolute:
            self = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self = .relativeToSafeAreaBottom(offset: newValue)
        case .relativeToTabBar:
            self = .relativeToTabBar(offset: newValue)
        }
    }
}
