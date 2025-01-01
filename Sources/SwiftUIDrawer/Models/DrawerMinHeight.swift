import UIKit

@MainActor
public enum DrawerMinHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(CGFloat) // Value of 0: Drag handle is on top of the safe area
    case relativeToTabBar(CGFloat) // Value of 0: Drag handle is on top of the tab bar
    case matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(CGFloat = 0) // Value will be calculated. Can be 0 during init
    case matchesStickyHeaderContentHeightAlignedToTabBar(CGFloat = 0) // Value will be calculated. Can be 0 during init

    public var absoluteValue: CGFloat {
        let value: CGFloat
        
        switch self {
        case let .absolute(float):
            value = float + DrawerConstants.dragHandleHeight
        case let .relativeToSafeAreaBottom(float):
            value = UIApplication.shared.safeAreaInsets.bottom
                + float
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(float):
            value = UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(float):
            value = UIApplication.shared.safeAreaInsets.bottom
                + float
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToTabBar(float):
            print("UIApplication.shared.safeAreaInsets.bottom: ", UIApplication.shared.safeAreaInsets.bottom)
            print("TabBarHeightProvider.sharedInstance.height: ", TabBarHeightProvider.sharedInstance.height)
            print("float: ", float)
            print("DrawerConstants.dragHandleHeight: ", DrawerConstants.dragHandleHeight)
            value = UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        }
        
        print("value: ", value)
        return value
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
            self = .relativeToSafeAreaBottom(newValue)
        case .relativeToTabBar:
            self = .relativeToTabBar(newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(newValue)
        case .matchesStickyHeaderContentHeightAlignedToTabBar:
            self = .matchesStickyHeaderContentHeightAlignedToTabBar(newValue)
        }
    }
}
