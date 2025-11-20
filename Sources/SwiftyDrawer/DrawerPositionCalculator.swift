import SwiftUI
import UIKit

@MainActor
public class DrawerPositionCalculator {
    private let tabBarFrameProvider: TabBarFrameProviding

    let containerBounds: CGRect // Screen bounds minus safe area insets
    let safeAreaInsets: EdgeInsets
    var dragHandleHeight: Double
    var drawerHeight: Double {
        containerBounds.height + safeAreaInsets.bottom
    }
    var tabBarHeight: Double { tabBarFrameProvider.frame.height }

    public init(
        screenBounds: CGRect,
        safeAreaInsets: EdgeInsets,
        tabBarFrameProvider: TabBarFrameProviding = TabBarFrameProvider.sharedInstance,
        dragHandleHeight: Double = DrawerConstants.dragHandleHeight
    ) {
        self.containerBounds = screenBounds
        self.safeAreaInsets = safeAreaInsets
        self.tabBarFrameProvider = tabBarFrameProvider
        self.dragHandleHeight = dragHandleHeight
    }

    /// The returned value controls the drawer's position on the screen
    func paddingTop(for state: DrawerState) -> Double {
        drawerHeight - state.currentPosition
    }

    func absoluteValue(for bottomPosition: DrawerBottomPosition) -> Double {
        switch bottomPosition {
        case let .absolute(double):
            double + dragHandleHeight
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsets.bottom
            + offset
            + dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsets.bottom
            + tabBarFrameProvider.frame.height
            + offset
            + dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight):
            safeAreaInsets.bottom
            + stickyHeaderHeight
            + dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight):
            safeAreaInsets.bottom
            + tabBarFrameProvider.frame.height
            + stickyHeaderHeight
            + dragHandleHeight
        }
    }

    func absoluteValue(for midPosition: DrawerMidPosition) -> Double {
        switch midPosition {
        case let .absolute(double):
            double
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsets.bottom
            + offset
            + dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsets.bottom
            + tabBarFrameProvider.frame.height
            + offset
            + dragHandleHeight
        }
    }

    func absoluteValue(for topPosition: DrawerTopPosition) -> Double {
        switch topPosition {
        case let .absolute(double):
            return double
        case let .relativeToSafeAreaTop(offset):
            print("screen: \(containerBounds.height)")
            print("safeArea: \(safeAreaInsets.top)")
            print("offset: \(offset)")

            return containerBounds.height
            + safeAreaInsets.bottom
            - offset
        }
    }

    func floatingButtonsOpacity(
        currentDrawerPosition: Double,
        drawerBottomPosition: DrawerBottomPosition,
        drawerMidPosition: DrawerMidPosition?
    ) -> Double {
        let positionModifier = UIScreen.main.scale > 2 ? 200.0 : 100
        let positionThreshold = if let drawerMidPosition {
            absoluteValue(for: drawerMidPosition)
        } else {
            absoluteValue(for: drawerBottomPosition)
        }

        return (positionThreshold + positionModifier - currentDrawerPosition) / 100.0
    }
}
