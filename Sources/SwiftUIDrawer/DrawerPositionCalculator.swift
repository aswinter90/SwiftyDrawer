import UIKit
import SwiftUI

public class DrawerPositionCalculator {
    private let safeAreaInsetsProvider: SafeAreaInsetsProviding
    private let tabBarFrameProvider: TabBarFrameProviding

    let screenBounds: CGRect
    var dragHandleHeight: CGFloat
    var screenHeight: CGFloat { screenBounds.height }
    var safeAreaInsets: UIEdgeInsets { safeAreaInsetsProvider.insets }
    var tabBarHeight: CGFloat { tabBarFrameProvider.frame.height }
    
    public init(
        screenBounds: CGRect,
        safeAreaInsetsProvider: SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: TabBarFrameProviding = TabBarFrameProvider.sharedInstance,
        dragHandleHeight: CGFloat = DrawerConstants.dragHandleHeight
    ) {
        self.screenBounds = screenBounds
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
        self.dragHandleHeight = dragHandleHeight
    }
    
    /// Property that controls the drawer's position on the screen by adding a top padding.
    func paddingTop(for state: DrawerState) -> CGFloat {
        screenHeight - state.currentPosition
    }

    /// This makes sure that the scrollable content is not covered by the tab bar or the lower safe area when the drawer is open
    func contentBottomPadding(for state: DrawerState, bottomPosition: DrawerBottomPosition) -> CGFloat {
        switch state.case {
        case .fullyOpened:
            paddingTop(for: state)
            + safeAreaInsets.bottom
            + (bottomPosition.isAlignedToTabBar ? tabBarHeight : 0)
        default:
            0
        }
    }
    
    func absoluteValue(for bottomPosition: DrawerBottomPosition) -> CGFloat {
        switch bottomPosition {
        case let .absolute(float):
            float + dragHandleHeight
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsetsProvider.insets.bottom
            + offset
            + dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsetsProvider.insets.bottom
            + tabBarFrameProvider.frame.height
            + offset
            + dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight):
            safeAreaInsetsProvider.insets.bottom
            + stickyHeaderHeight
            + dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight):
            safeAreaInsetsProvider.insets.bottom
            + tabBarFrameProvider.frame.height
            + stickyHeaderHeight
            + dragHandleHeight
        }
    }
    
    func absoluteValue(for midPosition: DrawerMidPosition) -> CGFloat {
        switch midPosition {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsetsProvider.insets.bottom
            + offset
            + dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsetsProvider.insets.bottom
            + tabBarFrameProvider.frame.height
            + offset
            + dragHandleHeight
        }
    }
    
    func absoluteValue(for topPosition: DrawerTopPosition) -> CGFloat {
        switch topPosition {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaTop(offset):
            screenBounds.height
            - safeAreaInsetsProvider.insets.top
            - offset
        }
    }
    
    func floatingButtonsOpacity(
        currentDrawerPosition: CGFloat,
        drawerBottomPosition: DrawerBottomPosition,
        drawerMidPosition: DrawerMidPosition?
    ) -> CGFloat {
        let positionModifier = UIScreen.main.scale > 2 ? 200.0 : 100
        let positionThreshold = if let drawerMidPosition {
            absoluteValue(for: drawerMidPosition)
        } else {
            absoluteValue(for: drawerBottomPosition)
        }
        
        return (positionThreshold + positionModifier - currentDrawerPosition) / 100.0
    }
}
