import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay(
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(.relativeToSafeAreaBottom(0)),
        mediumHeight: Binding<DrawerMediumHeight?>? = .constant(DrawerConstants.drawerDefaultMediumHeightCase),
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
    
    @ViewBuilder
    private func dimmedDrawerBackground(
        isShown: Bool,
        drawerState: Binding<DrawerState>,
        drawerMinHeight: Binding<DrawerMinHeight>,
        drawerMediumHeight: Binding<DrawerMediumHeight?>?,
        drawerMaxHeight: Binding<DrawerMaxHeight> = .constant(.relativeToSafeAreaTop(0))
    ) -> some View {
        if isShown {
            overlay {
                DrawerDimmingView(
                    drawerState: drawerState,
                    drawerMinHeight: drawerMinHeight,
                    drawerMediumHeight: drawerMediumHeight ?? .constant(nil),
                    drawerMaxHeight: drawerMaxHeight
                )
                .ignoresSafeArea()
            }
        } else {
            self
        }
    }
}
