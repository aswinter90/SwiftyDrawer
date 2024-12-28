import UIKit

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
