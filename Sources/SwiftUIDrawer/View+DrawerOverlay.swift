import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay<StickyHeaderContent: View>(
        layoutingStrategy: Binding<DrawerContentLayoutingStrategy> = .constant(.classic),
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(.relativeToSafeAreaBottom(0)),
        mediumHeight: Binding<DrawerMediumHeight>? = .constant(DrawerConstants.drawerDefaultMediumHeight),
        maxHeight: Binding<DrawerMaxHeight> = .constant(.relativeToSafeAreaTop(0)),
        isDimmingBackground: Bool = false,
        @ViewBuilder stickyHeader: () -> StickyHeaderContent? = { nil },
        animation: Animation = .smooth(duration: DrawerConstants.defaultAnimationDuration),
        @ViewBuilder content: () -> some View,
        contentViewEventHandler: DrawerContentCollectionViewEventHandler? = nil,
        originObservable: DrawerOriginObservable? = nil
    ) -> some View {
        dimmedDrawerBackground(
            isShown: isDimmingBackground,
            drawerState: state,
            drawerMinHeight: minHeight,
            drawerMediumHeight: mediumHeight,
            drawerMaxHeight: maxHeight
        )
        .overlay(alignment: .bottom, content: {
            Drawer(
                layoutingStrategy: layoutingStrategy,
                state: state,
                minHeight: minHeight,
                mediumHeight: mediumHeight,
                maxHeight: maxHeight,
                stickyHeader: stickyHeader(),
                animation: animation,
                content: content(),
                contentViewEventHandler: contentViewEventHandler,
                originObservable: originObservable
            )
        })
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
