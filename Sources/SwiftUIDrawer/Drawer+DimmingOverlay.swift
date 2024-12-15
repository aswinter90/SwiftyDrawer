import SwiftUI

extension View {
    @ViewBuilder
    func dimmedDrawerBackground(
        isShown: Bool,
        drawerState: Binding<DrawerState>,
        drawerMinHeight: Binding<DrawerMinHeight>,
        drawerMediumHeight: Binding<DrawerMediumHeight>?,
        drawerMaxHeight: DrawerMaxHeight
    ) -> some View {
        if isShown {
            overlay {
                DimmingView(
                    drawerState: drawerState,
                    drawerMinHeight: drawerMinHeight,
                    drawerMediumHeight: drawerMediumHeight,
                    drawerMaxHeight: drawerMaxHeight
                )
            }
            .ignoresSafeArea()
        } else {
            self
        }
    }
}
