import UIKit

public enum DrawerBottomPosition: Equatable, Sendable {
    case absolute(Double)
    case relativeToSafeAreaBottom(offset: Double) // Value of 0: Drag handle is on top of the safe area
    case matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: Double = 0) // Value will be calculated. Can be 0 during init

    var shouldMatchStickyHeaderHeight: Bool {
        switch self {
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            true
        default:
            false
        }
    }

    mutating func updateAssociatedValueOfCurrentCase(_ newValue: Double) {
        switch self {
        case .absolute:
            self = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            self = .relativeToSafeAreaBottom(offset: newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            self = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: newValue)
        }
    }
}
