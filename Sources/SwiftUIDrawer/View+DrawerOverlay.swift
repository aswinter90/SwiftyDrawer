import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay(
        state: Binding<DrawerState>,
        bottomPosition: Binding<DrawerBottomPosition> = .constant(.relativeToSafeAreaBottom(offset: 0)),
        midPosition: Binding<DrawerMidPosition?>? = .constant(DrawerConstants.drawerDefaultMidPosition),
        topPosition: Binding<DrawerTopPosition> = .constant(.relativeToSafeAreaTop(offset: 0)),
        isDimmingBackground: Bool = false,
        @ViewBuilder stickyHeader: () -> some View = { EmptyView() },
        @ViewBuilder content: () -> some View
    ) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .dimmedDrawerBackground(
                isShown: isDimmingBackground,
                drawerState: state,
                drawerBottomPosition: bottomPosition,
                drawerMidPosition: midPosition,
                drawerTopPosition: topPosition
            )
            .overlay(alignment: .bottom, content: {
                Drawer(
                    state: state,
                    bottomPosition: bottomPosition,
                    midPosition: midPosition,
                    topPosition: topPosition,
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
        drawerBottomPosition: Binding<DrawerBottomPosition>,
        drawerMidPosition: Binding<DrawerMidPosition?>?,
        drawerTopPosition: Binding<DrawerTopPosition> = .constant(.relativeToSafeAreaTop(offset: 0))
    ) -> some View {
        if isShown {
            overlay {
                DimmingView(
                    drawerState: drawerState,
                    drawerBottomPosition: drawerBottomPosition,
                    drawerMidPosition: drawerMidPosition ?? .constant(nil),
                    drawerTopPosition: drawerTopPosition
                )
                .ignoresSafeArea()
            }
        } else {
            self
        }
    }
}
