import UIKit

public struct DrawerMediumHeight: Equatable {
    @MainActor
    public enum Case: Equatable {
        case absolute(CGFloat)
        case relativeToSafeAreaBottom(offset: CGFloat)
        case relativeToTabBar(offset: CGFloat)
    }

    public let safeAreaInsetsProvider: any SafeAreaInsetsProviding
    public let tabBarFrameProvider: any TabBarFrameProviding
    
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
            self = .init(
                case: .absolute(newValue),
                safeAreaInsetsProvider: safeAreaInsetsProvider,
                tabBarFrameProvider: tabBarFrameProvider
            )
        case .relativeToSafeAreaBottom:
            self = .init(
                case: .relativeToSafeAreaBottom(offset: newValue),
                safeAreaInsetsProvider: safeAreaInsetsProvider,
                tabBarFrameProvider: tabBarFrameProvider
            )
        case .relativeToTabBar:
            self = .init(
                case: .relativeToTabBar(offset: newValue),
                safeAreaInsetsProvider: safeAreaInsetsProvider,
                tabBarFrameProvider: tabBarFrameProvider
            )
        }
    }
    
    nonisolated public static func ==(lhs: DrawerMediumHeight, rhs: DrawerMediumHeight) -> Bool {
        lhs.case == rhs.case
    }
}
