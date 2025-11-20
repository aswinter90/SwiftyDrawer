import SwiftUI
import UIKit

@MainActor
public class DrawerPositionCalculator {
    let containerBounds: CGRect // Screen bounds minus safe area insets
    let safeAreaInsets: EdgeInsets
    var dragHandleHeight: Double
    var drawerHeight: Double {
        containerBounds.height + safeAreaInsets.bottom
    }

    public init(
        containerBounds: CGRect,
        safeAreaInsets: EdgeInsets,
        dragHandleHeight: Double = DrawerConstants.dragHandleHeight
    ) {
        self.containerBounds = containerBounds
        self.safeAreaInsets = safeAreaInsets
        self.dragHandleHeight = dragHandleHeight
    }

    /// The returned value controls the drawer's position on the screen
    func paddingTop(for state: DrawerState) -> Double {
        drawerHeight - state.currentPosition
    }

    /// This assures that the scrollable content is not covered by the tab bar or the lower safe area when the drawer is open
    func contentBottomPadding(for state: DrawerState, bottomPosition: DrawerBottomPosition) -> Double {
        switch state.case {
        case .fullyOpened:
            paddingTop(for: state)
            + safeAreaInsets.bottom
        default:
            0
        }
    }

    func absoluteValue(for bottomPosition: DrawerBottomPosition) -> Double {
        switch bottomPosition {
        case let .absolute(double):
            double + dragHandleHeight
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsets.bottom
            + offset
            + dragHandleHeight
        case let .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight):
            safeAreaInsets.bottom
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
        }
    }

    func absoluteValue(for topPosition: DrawerTopPosition) -> Double {
        switch topPosition {
        case let .absolute(double):
            double
        case let .relativeToSafeAreaTop(offset):
            containerBounds.height
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
