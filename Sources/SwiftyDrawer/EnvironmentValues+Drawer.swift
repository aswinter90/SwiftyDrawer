import SwiftUI

extension EnvironmentValues {
    @Entry var drawerStyle = DrawerStyle()
    @Entry var drawerFloatingButtonShadowStyle = DrawerStyle.ShadowStyle(offset: .init(width: 0, height: 3))
    @Entry var drawerLayoutStrategy = DrawerContentLayoutStrategy.classic
    @Entry var drawerAnimation = Animation.smooth(duration: DrawerConstants.defaultAnimationDuration)
    @Entry var isDrawerHapticFeedbackEnabled = false

    @Entry var drawerFloatingButtonsConfiguration = DrawerFloatingButtonsConfiguration(
        leadingButtons: [],
        trailingButtons: []
    )

    @Entry var isApplyingRenderingOptimizationToDrawerHeader = true

    @Entry var drawerContentOffsetController: DrawerContentOffsetController?
    @Entry var drawerOriginObservable: DrawerOriginObservable?

    @Entry var drawerPartiallyOpenedStateContentContainerHeight: Double = 0
    @Entry var drawerStickyHeaderHeight: Double = 0
}

public extension View {
    func drawerStyle(_ drawerStyle: DrawerStyle) -> some View {
        environment(\.drawerStyle, drawerStyle)
    }

    func drawerLayoutStrategy(_ layoutStrategy: DrawerContentLayoutStrategy) -> some View {
        environment(\.drawerLayoutStrategy, layoutStrategy)
    }

    func drawerAnimation(_ animation: Animation) -> some View {
        environment(\.drawerAnimation, animation)
    }

    func isDrawerHapticFeedbackEnabled(_ isEnabled: Bool) -> some View {
        environment(\.isDrawerHapticFeedbackEnabled, isEnabled)
    }

    func drawerFloatingButtonsConfiguration(_ configuration: DrawerFloatingButtonsConfiguration) -> some View {
        environment(\.drawerFloatingButtonsConfiguration, configuration)
    }

    /// By default, the drawer header  is using a `drawingGroup` modifier to prevent glitchy animations when dragging the drawer or changing its state programmatically. Unfortunately this comes with some implications, for example the inability to use a `ScrollView` or any other view backed by native platform, which are simply not rendered. Use this environment value to disable this optimization.
    func isApplyingRenderingOptimizationToDrawerHeader(_ isApplying: Bool) -> some View {
        environment(\.isApplyingRenderingOptimizationToDrawerHeader, isApplying)
    }

    func drawerContentOffsetController(_ controller: DrawerContentOffsetController?) -> some View {
        environment(\.drawerContentOffsetController, controller)
    }

    func drawerOriginObservable(_ observable: DrawerOriginObservable?) -> some View {
        environment(\.drawerOriginObservable, observable)
    }
}
