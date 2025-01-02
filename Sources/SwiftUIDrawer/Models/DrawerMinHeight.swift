import UIKit

@MainActor
public enum DrawerMinHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(offset: CGFloat) // Value of 0: Drag handle is on top of the safe area
    case relativeToTabBar(offset: CGFloat) // Value of 0: Drag handle is on top of the tab bar
    case matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init
    case matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init

    public var value: CGFloat {
        switch self {
        case let .absolute(float):
            float + DrawerConstants.dragHandleHeight
        case let .relativeToSafeAreaBottom(offset):
            UIApplication.shared.safeAreaInsets.bottom
                + offset
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(offset):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + offset
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight):
            UIApplication.shared.safeAreaInsets.bottom
                + stickyHeaderHeight
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + stickyHeaderHeight
                + DrawerConstants.dragHandleHeight
        }
    }
    
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
    
    mutating func updateAssociatedValue(_ newValue: CGFloat) {
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
