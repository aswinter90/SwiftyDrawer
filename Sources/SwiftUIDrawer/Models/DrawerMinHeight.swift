import UIKit

@MainActor
public enum DrawerMinHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(CGFloat) // Value of 0: Drag handle is on top of the safe area
    case relativeToTabBar(CGFloat) // Value of 0: Drag handle is on top of the tab bar
    case equalToStickyHeaderContentHeightAlignedToSafeAreaBottom(CGFloat) // Value will be calculated. May be 0 during init
    case equalToStickyHeaderContentHeightAlignedToTabBar(CGFloat) // Value will be calculated. May be 0 during init

    public var absoluteValue: CGFloat {
        switch self {
        case let .absolute(float):
            float + DrawerConstants.dragHandleHeight
        case let .relativeToSafeAreaBottom(float):
            UIApplication.shared.safeAreaInsets.bottom
                + float
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(float):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        case let .equalToStickyHeaderContentHeightAlignedToSafeAreaBottom(float):
            UIApplication.shared.safeAreaInsets.bottom
                + float
                + DrawerConstants.dragHandleHeight
        case let .equalToStickyHeaderContentHeightAlignedToTabBar(float):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        }
    }

    var isEqualToStickyHeaderHeight: Bool {
        switch self {
        case .equalToStickyHeaderContentHeightAlignedToSafeAreaBottom, .equalToStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }

    var isAlignedToTabBar: Bool {
        switch self {
        case .relativeToTabBar, .equalToStickyHeaderContentHeightAlignedToTabBar:
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
            self = .relativeToSafeAreaBottom(newValue)
        case .relativeToTabBar:
            self = .relativeToTabBar(newValue)
        case .equalToStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self = .equalToStickyHeaderContentHeightAlignedToSafeAreaBottom(newValue)
        case .equalToStickyHeaderContentHeightAlignedToTabBar:
            self = .equalToStickyHeaderContentHeightAlignedToTabBar(newValue)
        }
    }
}
