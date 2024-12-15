import SwiftUI

public struct DrawerFloatingButtonsConfigurationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DrawerFloatingButtonsConfiguration = .init(
        firstButtonProperties: nil,
        secondButtonProperties: nil
    )
}

public extension EnvironmentValues {
    var drawerFloatingButtonsConfiguration: DrawerFloatingButtonsConfiguration {
        get { self[DrawerFloatingButtonsConfigurationEnvironmentKey.self] }
        set { self[DrawerFloatingButtonsConfigurationEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func drawerFloatingButtonsConfiguration(_ configuration: DrawerFloatingButtonsConfiguration) -> some View {
        environment(\.drawerFloatingButtonsConfiguration, configuration)
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
