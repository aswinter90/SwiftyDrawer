import UIKit

public extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .init()
    }
}
