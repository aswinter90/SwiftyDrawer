import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay(
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(.relativeToSafeAreaBottom(0)),
        mediumHeight: Binding<DrawerMediumHeight>? = .constant(DrawerConstants.drawerDefaultMediumHeight),
        maxHeight: Binding<DrawerMaxHeight> = .constant(.relativeToSafeAreaTop(0)),
        isDimmingBackground: Bool = false,
        @ViewBuilder stickyHeader: () -> some View = { EmptyView() },
        @ViewBuilder content: () -> some View
    ) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .dimmedDrawerBackground(
                isShown: isDimmingBackground,
                drawerState: state,
                drawerMinHeight: minHeight,
                drawerMediumHeight: mediumHeight,
                drawerMaxHeight: maxHeight
            )
            .overlay(alignment: .bottom, content: {
                Drawer(
                    state: state,
                    minHeight: minHeight,
                    mediumHeight: mediumHeight,
                    maxHeight: maxHeight,
                    stickyHeader: stickyHeader(),
                    content: content()
                )
            })
            .ignoresSafeArea(.container, edges: .bottom)
    }
}
