import UIKit

public enum DrawerBottomPosition: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(offset: CGFloat) // Value of 0: Drag handle is on top of the safe area
    case relativeToTabBar(offset: CGFloat) // Value of 0: Drag handle is on top of the tab bar
    case matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init
    case matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init
    
    var shouldMatchStickyHeaderHeight: Bool {
        switch self {
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom, .matchesStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }
    
    var isAlignedToTabBar: Bool {
        switch self {
        case .relativeToTabBar, .matchesStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }
    
    mutating func updateAssociatedValueOfCurrentCase(_ newValue: CGFloat) {
        switch self {
        case .absolute:
            self = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self = .relativeToSafeAreaBottom(offset: newValue)
        case .relativeToTabBar:
            self = .relativeToTabBar(offset: newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: newValue)
        case .matchesStickyHeaderContentHeightAlignedToTabBar:
            self = .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: newValue)
        }
    }
}
