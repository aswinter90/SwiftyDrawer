import SwiftUI

extension EnvironmentValues {
    @Entry var drawerStyle = DrawerStyle()
    @Entry var drawerFloatingButtonShadowStyle = DrawerStyle.ShadowStyle(offset: .init(width: 0, height: 3))
    @Entry var drawerLayoutStrategy = DrawerContentLayoutStrategy.classic
    @Entry var drawerAnimation = Animation.smooth(duration: DrawerConstants.defaultAnimationDuration)
    
    @Entry var drawerFloatingButtonsConfiguration = DrawerFloatingButtonsConfiguration(
        leadingButtons: [],
        trailingButtons: []
    )
    
    @Entry var drawerContentOffsetController: DrawerContentOffsetController?
    @Entry var drawerOriginObservable: DrawerOriginObservable?
    
    @Entry var drawerPartiallyOpenedStateContentContainerHeight: CGFloat = 0
    @Entry var drawerStickyHeaderHeight: CGFloat = 0
    
    @Entry var viewBounds: CGSize = .zero
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
    
    func drawerFloatingButtonsConfiguration(_ configuration: DrawerFloatingButtonsConfiguration) -> some View {
        environment(\.drawerFloatingButtonsConfiguration, configuration)
    }
    
    func drawerContentOffsetController(_ controller: DrawerContentOffsetController?) -> some View {
        environment(\.drawerContentOffsetController, controller)
    }
    
    func drawerOriginObservable(_ observable: DrawerOriginObservable?) -> some View {
        environment(\.drawerOriginObservable, observable)
    }
}

extension View {
    func viewBounds(_ bounds: CGSize) -> some View {
        environment(\.viewBounds, bounds)
    }
}
