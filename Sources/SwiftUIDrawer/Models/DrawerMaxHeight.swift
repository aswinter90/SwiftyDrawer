import UIKit

public struct DrawerMaxHeight: Equatable {
    @MainActor
    public enum Case: Equatable {
        case absolute(CGFloat)
        case relativeToSafeAreaTop(offset: CGFloat)
    }
    
    public let screenBoundsProvider: any ScreenBoundsProviding
    public let safeAreaInsetsProvider: any SafeAreaInsetsProviding
    public let tabBarFrameProvider: any TabBarFrameProviding
    
    public var `case`: Case
    
    public init(
        case: Case,
        screenBoundsProvider: ScreenBoundsProviding = UIScreen.main,
        safeAreaInsetsProvider: SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: TabBarFrameProviding = TabBarFrameProvider.sharedInstance
    ) {
        self.case = `case`
        self.screenBoundsProvider = screenBoundsProvider
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
    }
    
    var value: CGFloat {
        switch `case` {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaTop(offset):
            screenBoundsProvider.bounds.height
                - safeAreaInsetsProvider.insets.top
                - offset
        }
    }
    
    nonisolated public static func ==(lhs: DrawerMaxHeight, rhs: DrawerMaxHeight) -> Bool {
        lhs.case == rhs.case
    }
}
