import UIKit

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
