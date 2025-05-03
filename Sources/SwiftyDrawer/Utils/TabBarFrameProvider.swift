import UIKit

public protocol TabBarFrameProviding: Sendable {
    var frame: CGRect { get }
}

@MainActor
public final class TabBarFrameProvider: TabBarFrameProviding {
    public static let sharedInstance: TabBarFrameProvider = .init()

    public let frame = UITabBarController().tabBar.frame

    public init() {}
}
