import UIKit

@MainActor
public enum DrawerMaxHeight: Equatable {
    case absolute(CGFloat)
    case relativeToSafeAreaTop(offset: CGFloat)

    var value: CGFloat {
        switch self {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaTop(offset):
            UIScreen.main.bounds.height - UIApplication.shared.insets.top - offset
        }
    }
}
