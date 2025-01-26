import UIKit
import SwiftUI

public class DrawerPositionCalculator {
    let screenBoundsProvider: ScreenBoundsProviding
    let safeAreaInsetsProvider: SafeAreaInsetsProviding
    let tabBarFrameProvider: TabBarFrameProviding
    var dragHandleHeight: CGFloat
    
    public init(
        screenBoundsProvider: ScreenBoundsProviding = UIScreen.main,
        safeAreaInsetsProvider: SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: TabBarFrameProviding = TabBarFrameProvider.sharedInstance,
        dragHandleHeight: CGFloat = DrawerConstants.dragHandleHeight
    ) {
        self.screenBoundsProvider = screenBoundsProvider
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
        self.dragHandleHeight = dragHandleHeight
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
            screenBoundsProvider.bounds.height
                - safeAreaInsetsProvider.insets.top
                - offset
        }
    }
}
