import UIKit

public protocol SafeAreaInsetsProviding {
    var insets: UIEdgeInsets { get }
}

extension UIApplication: SafeAreaInsetsProviding {
    public var insets: UIEdgeInsets {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .init()
    }
}
