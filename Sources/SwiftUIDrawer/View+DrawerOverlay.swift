import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay(
        state: Binding<DrawerState>,
        bottomPosition: Binding<DrawerBottomPosition> = .constant(.relativeToSafeAreaBottom(offset: 0)),
        midPosition: DrawerMidPosition? = DrawerConstants.drawerDefaultMidPosition,
        topPosition: DrawerTopPosition = .relativeToSafeAreaTop(offset: 0),
        isDimmingBackground: Bool = false,
        positionCalculator: DrawerPositionCalculator = .init(),
        @ViewBuilder stickyHeader: () -> some View = { EmptyView() },
        @ViewBuilder content: () -> some View
    ) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .dimmedDrawerBackground(
                isShown: isDimmingBackground,
                drawerState: state.wrappedValue,
                drawerBottomPosition: bottomPosition.wrappedValue,
                drawerMidPosition: midPosition,
                drawerTopPosition: topPosition,
                positionCalculator: positionCalculator
            )
            .overlay(alignment: .bottom, content: {
                Drawer(
                    state: state,
                    bottomPosition: bottomPosition,
                    midPosition: midPosition,
                    topPosition: topPosition,
                    positionCalculator: positionCalculator,
                    stickyHeader: stickyHeader(),
                    content: content()
                )
            })
            .ignoresSafeArea(.container, edges: .bottom)
    }
    
    @ViewBuilder
    private func dimmedDrawerBackground(
        isShown: Bool,
        drawerState: DrawerState,
        drawerBottomPosition: DrawerBottomPosition,
        drawerMidPosition: DrawerMidPosition?,
        drawerTopPosition: DrawerTopPosition = .relativeToSafeAreaTop(offset: 0),
        positionCalculator: DrawerPositionCalculator = .init()
    ) -> some View {
        if isShown {
            overlay {
                DimmingView(
                    drawerState: drawerState,
                    drawerBottomPosition: drawerBottomPosition,
                    drawerMidPosition: drawerMidPosition,
                    drawerTopPosition: drawerTopPosition,
                    positionCalculator: positionCalculator
                )
                .ignoresSafeArea()
            }
        } else {
            self
        }
    }
}
