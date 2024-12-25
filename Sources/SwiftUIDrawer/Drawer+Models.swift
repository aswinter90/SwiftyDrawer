import Combine
import SwiftUI
import UIKit

// MARK: - Enums

public enum DrawerContentLayoutStrategy {
    /// Robust option which is based on an `UICollectionViewFlowLayout`, but animated content size-changes can look choppy.
    case classic

    /// Better adapts to animated size-changes by leveraging a `UICollectionViewCompositionalLayout`, but can show glitchy or jumpy behavior when swapping out content, e.g. in a typical transition from a list to a detail view.
    case modern
}

public struct DrawerState {
    public enum Case {
        case closed
        case partiallyOpened
        case fullyOpened
    }

    public var `case`: Case
    public internal(set) var currentHeight: CGFloat = 0.0

    public init(case: Case) {
        self.case = `case`
    }
}

@MainActor
public enum DrawerMaxHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaTop(CGFloat)

    var absoluteValue: CGFloat {
        switch self {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaTop(float):
            UIScreen.main.bounds.height - UIApplication.shared.safeAreaInsets.top - float
        }
    }
}

@MainActor
public enum DrawerMinHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(CGFloat) // Value of 0: Drag handle is on top of the safe area
    case relativeToTabBar(CGFloat) // Value of 0: Drag handle is on top of the tab bar
    case sameAsStickyHeaderContentHeightAlignedToSafeAreaBottom(CGFloat) // Value will be calculated. May be 0 during init
    case sameAsStickyHeaderContentHeightAlignedToTabBar(CGFloat) // Value will be calculated. May be 0 during init

    public var absoluteValue: CGFloat {
        switch self {
        case let .absolute(float):
            float + DrawerConstants.dragHandleHeight
        case let .relativeToSafeAreaBottom(float):
            UIApplication.shared.safeAreaInsets.bottom + float + DrawerConstants
                .dragHandleHeight
        case let .relativeToTabBar(float):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        case let .sameAsStickyHeaderContentHeightAlignedToSafeAreaBottom(float):
            UIApplication.shared.safeAreaInsets.bottom + float + DrawerConstants
                .dragHandleHeight
        case let .sameAsStickyHeaderContentHeightAlignedToTabBar(float):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        }
    }

    var isSameAsStickyHeaderHeight: Bool {
        switch self {
        case .sameAsStickyHeaderContentHeightAlignedToSafeAreaBottom, .sameAsStickyHeaderContentHeightAlignedToTabBar:
            true
        default:
            false
        }
    }

    var isAlignedToTabBar: Bool {
        switch self {
        case .relativeToTabBar, .sameAsStickyHeaderContentHeightAlignedToTabBar:
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
        case .sameAsStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self = .sameAsStickyHeaderContentHeightAlignedToSafeAreaBottom(newValue)
        case .sameAsStickyHeaderContentHeightAlignedToTabBar:
            self = .sameAsStickyHeaderContentHeightAlignedToTabBar(newValue)
        }
    }
}

@MainActor
public enum DrawerMediumHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(CGFloat)
    case relativeToSafeAreaBottomAndTabBar(CGFloat)

    public var absoluteValue: CGFloat {
        switch self {
        case let .absolute(float): float
        case let .relativeToSafeAreaBottom(float):
            UIApplication.shared.safeAreaInsets.bottom + float + DrawerConstants
                .dragHandleHeight
        case let .relativeToSafeAreaBottomAndTabBar(float):
            UIApplication.shared.safeAreaInsets.bottom
                + TabBarHeightProvider.sharedInstance.height
                + float
                + DrawerConstants.dragHandleHeight
        }
    }

    public var associatedValue: CGFloat {
        switch self {
        case let .absolute(float): float
        case let .relativeToSafeAreaBottom(float): float
        case let .relativeToSafeAreaBottomAndTabBar(float): float
        }
    }

    mutating func updateAssociatedValue(_ newValue: CGFloat) {
        switch self {
        case .absolute:
            self = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self = .relativeToSafeAreaBottom(newValue)
        case .relativeToSafeAreaBottomAndTabBar:
            self = .relativeToSafeAreaBottomAndTabBar(newValue)
        }
    }
}

// MARK: - Constants

public enum DrawerConstants {
    public static let dragHandleHeight = 28.0
    public static let drawerDefaultMediumHeightCase = DrawerMediumHeight.relativeToSafeAreaBottomAndTabBar(328)
    public static let defaultAnimationDuration = 0.32
    public static let drawerCornerRadius = 14.0
    static let floatingButtonsPadding = 16.0
    static let draggingVelocityThreshold = 200.0
    static let appleMapAttributionLabelPadding = 5.0
}

// MARK: - Nested types

extension Drawer {
    enum DragTargetDirection {
        case up
        case down
        case undefined

        init(startLocationY: CGFloat, endLocationY: CGFloat, velocity: CGFloat) {
            let isSlowGesture = abs(velocity) < DrawerConstants.draggingVelocityThreshold

            if isSlowGesture {
                self = .undefined
            } else {
                self = endLocationY > startLocationY ? .down : .up
            }
        }
    }

    /// Used for interpolating values of the drawer position during animations.
    struct OffsetEffect: GeometryEffect {
        var value: CGFloat
        var onValueDidChange: (CGFloat) -> Void

        var animatableData: CGFloat {
            get { value }
            set { value = newValue }
        }

        func effectValue(size _: CGSize) -> ProjectionTransform {
            onValueDidChange(value)
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: value))
        }
    }
}
