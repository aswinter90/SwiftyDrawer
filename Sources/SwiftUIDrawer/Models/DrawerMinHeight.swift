import UIKit

public struct DrawerMinHeight: Equatable {
    @MainActor
    public enum Case: Equatable {
        case absolute(CGFloat)
        case relativeToSafeAreaBottom(offset: CGFloat) // Value of 0: Drag handle is on top of the safe area
        case relativeToTabBar(offset: CGFloat) // Value of 0: Drag handle is on top of the tab bar
        case matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init
        case matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: CGFloat = 0) // Value will be calculated. Can be 0 during init
    }
    
    public let safeAreaInsetsProvider: any SafeAreaInsetsProviding
    public let tabBarFrameProvider: any TabBarFrameProviding
    
    public var `case`: Case
    
    public init(
        case: Case,
        safeAreaInsetsProvider: any SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: any TabBarFrameProviding = TabBarFrameProvider.sharedInstance
    ) {
        self.case = `case`
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
    }
    
    public var value: CGFloat {
        switch `case` {
        case let .absolute(float):
            float + DrawerConstants.dragHandleHeight
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsetsProvider.insets.bottom
                + offset
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsetsProvider.insets.bottom
                + tabBarFrameProvider.frame.height
                + offset
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight):
            safeAreaInsetsProvider.insets.bottom
                + stickyHeaderHeight
                + DrawerConstants.dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight):
            safeAreaInsetsProvider.insets.bottom
                + tabBarFrameProvider.frame.height
                + stickyHeaderHeight
                + DrawerConstants.dragHandleHeight
        }
    }
    
    var shouldMatchStickyHeaderHeight: Bool {
        switch `case` {
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom, .matchesStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }

    var isAlignedToTabBar: Bool {
        switch `case` {
        case .relativeToTabBar, .matchesStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }
    
    mutating func updateAssociatedValue(_ newValue: CGFloat) {
        switch `case` {
        case .absolute:
            self.case = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self.case = .relativeToSafeAreaBottom(offset: newValue)
        case .relativeToTabBar:
            self.case = .relativeToTabBar(offset: newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self.case = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: newValue)
        case .matchesStickyHeaderContentHeightAlignedToTabBar:
            self.case = .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: newValue)
        }
    }
    
    nonisolated public static func ==(lhs: DrawerMinHeight, rhs: DrawerMinHeight) -> Bool {
        lhs.case == rhs.case
    }
}
