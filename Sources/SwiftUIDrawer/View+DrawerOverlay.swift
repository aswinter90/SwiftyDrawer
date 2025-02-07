import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay(
        state: Binding<DrawerState>,
        bottomPosition: Binding<DrawerBottomPosition> = .constant(.relativeToSafeAreaBottom(offset: 0)),
        midPosition: DrawerMidPosition? = DrawerConstants.drawerDefaultMidPosition,
        topPosition: DrawerTopPosition = .relativeToSafeAreaTop(offset: 0),
        isDimmingBackground: Bool = false,
        @ViewBuilder stickyHeader: @escaping () -> some View = { EmptyView() },
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(
            DrawerOverlayModifier(
                state: state,
                bottomPosition: bottomPosition,
                midPosition: midPosition,
                topPosition: topPosition,
                isDimmingBackground: isDimmingBackground,
                stickyHeader: stickyHeader,
                drawerContent: content
            )
        )
    }
}
