import UIKit

public protocol TabBarFrameProviding {
    var frame: CGRect { get }
}

public final class TabBarFrameProvider: TabBarFrameProviding {
    public static let sharedInstance: TabBarFrameProvider = .init()
    
    public let frame = UITabBarController().tabBar.frame

    public init() {}
}
