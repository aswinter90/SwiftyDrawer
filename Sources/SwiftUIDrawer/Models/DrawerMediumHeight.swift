import UIKit

@MainActor
public enum DrawerMediumHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaBottom(offset: CGFloat)
    case relativeToTabBar(offset: CGFloat)

    public var value: CGFloat {
        switch self {
        case let .absolute(float): float
        case let .relativeToSafeAreaBottom(offset):
            UIApplication.shared.insets.bottom
                + offset
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(offset):
            UIApplication.shared.insets.bottom
                + TabBarFrameProvider.sharedInstance.frame.height
                + offset
                + DrawerConstants.dragHandleHeight
        }
    }

    mutating func updateAssociatedValue(_ newValue: CGFloat) {
        switch self {
        case .absolute:
            self = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self = .relativeToSafeAreaBottom(offset: newValue)
        case .relativeToTabBar:
            self = .relativeToTabBar(offset: newValue)
        }
    }
}
