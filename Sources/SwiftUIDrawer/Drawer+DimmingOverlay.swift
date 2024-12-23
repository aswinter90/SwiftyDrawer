import SwiftUI

extension View {
    @ViewBuilder
    func dimmedDrawerBackground(
        isShown: Bool,
        drawerState: Binding<DrawerState>,
        drawerMinHeight: Binding<DrawerMinHeight>,
        drawerMediumHeight: Binding<DrawerMediumHeight?>?,
        drawerMaxHeight: Binding<DrawerMaxHeight> = .constant(.relativeToSafeAreaTop(0))
    ) -> some View {
        if isShown {
            overlay {
                DimmingView(
                    drawerState: drawerState,
                    drawerMinHeight: drawerMinHeight,
                    drawerMediumHeight: drawerMediumHeight ?? .constant(nil),
                    drawerMaxHeight: drawerMaxHeight
                )
            }
            .ignoresSafeArea()
        } else {
            self
        }
    }
}
