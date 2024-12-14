import SwiftUI

public struct DrawerFloatingButtonsEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DrawerFloatingButtons = .init(firstConfiguration: nil, secondConfiguration: nil)
}

public extension EnvironmentValues {
    var drawerFloatingButtons: DrawerFloatingButtons {
        get { self[DrawerFloatingButtonsEnvironmentKey.self] }
        set { self[DrawerFloatingButtonsEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func drawerFloatingButtons(_ configuration: DrawerFloatingButtons) -> some View {
        environment(\.drawerFloatingButtons, configuration)
    }
}

public struct MediumDrawerContentHeightEnvironmentKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    var mediumDrawerContentHeight: CGFloat {
        get { self[MediumDrawerContentHeightEnvironmentKey.self] }
        set { self[MediumDrawerContentHeightEnvironmentKey.self] = newValue }
    }
}

public struct DrawerStickyHeaderHeightEnvironmentKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    var drawerStickyHeaderHeight: CGFloat {
        get { self[DrawerStickyHeaderHeightEnvironmentKey.self] }
        set { self[DrawerStickyHeaderHeightEnvironmentKey.self] = newValue }
    }
}
