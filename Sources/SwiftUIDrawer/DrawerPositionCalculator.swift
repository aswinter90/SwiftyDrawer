import UIKit
import SwiftUI

class DrawerPositionCalculator {
    let screenBoundsProvider: ScreenBoundsProviding
    let safeAreaInsetsProvider: SafeAreaInsetsProviding
    let tabBarFrameProvider: TabBarFrameProviding
    var dragHandleHeight: CGFloat
    
    @Binding var bottomPosition: DrawerBottomPosition
    @Binding var topPosition: DrawerTopPosition
    @Binding var midPosition: DrawerMidPosition?
    
    init(
        screenBoundsProvider: ScreenBoundsProviding = UIScreen.main,
        safeAreaInsetsProvider: any SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: any TabBarFrameProviding = TabBarFrameProvider.sharedInstance,
        dragHandleHeight: CGFloat = DrawerConstants.dragHandleHeight,
        bottomPosition: Binding<DrawerBottomPosition> = .constant(.relativeToSafeAreaBottom(offset: 0)),
        midPosition: Binding<DrawerMidPosition?>? = .constant(DrawerConstants.drawerDefaultMidPosition),
        topPosition: Binding<DrawerTopPosition> = .constant(.relativeToSafeAreaTop(offset: 0))
    ) {
        self.screenBoundsProvider = screenBoundsProvider
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
        self.dragHandleHeight = dragHandleHeight
        _bottomPosition = bottomPosition
        _midPosition = midPosition ?? .constant(nil)
        _topPosition = topPosition
    }
    
    func height(for drawerState: DrawerState.Case) -> CGFloat {
        switch drawerState {
        case .closed:
            calculateAbsoluteValue(for: bottomPosition)
        case .partiallyOpened:
            if let midPosition {
                calculateAbsoluteValue(for: midPosition)
            } else {
                fatalError("Cannot return height for `partiallyOpened` state when no medium height was defined")
            }
        case .fullyOpened:
            calculateAbsoluteValue(for: topPosition)
        }
    }
    
    private func calculateAbsoluteValue(for bottomPosition: DrawerBottomPosition) -> CGFloat {
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
    
    private func calculateAbsoluteValue(for midPosition: DrawerMidPosition) -> CGFloat {
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
    
    private func calculateAbsoluteValue(for topPosition: DrawerTopPosition) -> CGFloat {
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
