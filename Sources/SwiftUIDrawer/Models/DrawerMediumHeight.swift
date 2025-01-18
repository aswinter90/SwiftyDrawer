import UIKit

public struct DrawerMediumHeight: Equatable {
    @MainActor
    public enum Case: Equatable {
        case absolute(CGFloat)
        case relativeToSafeAreaBottom(offset: CGFloat)
        case relativeToTabBar(offset: CGFloat)
    }

    public let safeAreaInsetsProvider: SafeAreaInsetsProviding
    public let tabBarFrameProvider: TabBarFrameProviding
    
    public var `case`: Case
    
    public init(
        case: Case,
        safeAreaInsetsProvider: SafeAreaInsetsProviding = UIApplication.shared,
        tabBarFrameProvider: TabBarFrameProviding = TabBarFrameProvider.sharedInstance
    ) {
        self.case = `case`
        self.safeAreaInsetsProvider = safeAreaInsetsProvider
        self.tabBarFrameProvider = tabBarFrameProvider
    }
    
    public var value: CGFloat {
        switch `case` {
        case let .absolute(float):
            float
        case let .relativeToSafeAreaBottom(offset):
            safeAreaInsetsProvider.insets.bottom
                + offset
                + DrawerConstants.dragHandleHeight
        case let .relativeToTabBar(offset):
            safeAreaInsetsProvider.insets.bottom
                + tabBarFrameProvider.frame.height
                + offset
                + DrawerConstants.dragHandleHeight
        }
    }
    
    mutating func updateAssociatedValue(_ newValue: CGFloat) {
        switch `case` {
        case .absolute:
            `case` = .absolute(newValue)
        case .relativeToSafeAreaBottom:
            `case` = .relativeToSafeAreaBottom(offset: newValue)
        case .relativeToTabBar:
            `case` = .relativeToTabBar(offset: newValue)
        }
    }
    
    nonisolated public static func ==(lhs: DrawerMediumHeight, rhs: DrawerMediumHeight) -> Bool {
        lhs.case == rhs.case
    }
}
