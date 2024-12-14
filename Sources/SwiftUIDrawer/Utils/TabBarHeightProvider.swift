import UIKit

@MainActor
public final class TabBarHeightProvider {
    public static let sharedInstance: TabBarHeightProvider = .init()

    public var height = UITabBarController().tabBar.frame.height

    init() {}
}
