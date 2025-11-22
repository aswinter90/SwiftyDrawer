import SwiftUI

struct DrawerOverlayModifier<StickyHeader: View, DrawerContent: View>: ViewModifier {
    let state: Binding<DrawerState>
    let bottomPosition: Binding<DrawerBottomPosition>
    let midPosition: DrawerMidPosition?
    let topPosition: DrawerTopPosition
    let isDimmingBackground: Bool
    @ViewBuilder let stickyHeader: () -> StickyHeader
    @ViewBuilder let drawerContent: () -> DrawerContent

    func body(content: Content) -> some View {
        ZStack {
            content

            GeometryReader { proxy in
                let positionCalculator = DrawerPositionCalculator(
                    containerBounds: proxy.frame(in: .global),
                    safeAreaInsets: proxy.safeAreaInsets
                )

                Color.clear
                    .dimmedDrawerBackground(
                        isShown: isDimmingBackground,
                        drawerState: state.wrappedValue,
                        drawerBottomPosition: bottomPosition.wrappedValue,
                        drawerMidPosition: midPosition,
                        drawerTopPosition: topPosition,
                        positionCalculator: positionCalculator
                    )
                    .overlay(
                        alignment: .bottom,
                        content: {
                            Drawer(
                                state: state,
                                bottomPosition: bottomPosition,
                                midPosition: midPosition,
                                topPosition: topPosition,
                                positionCalculator: positionCalculator,
                                stickyHeader: stickyHeader(),
                                content: drawerContent()
                            )
                        }
                    )
                    .ignoresSafeArea()
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func dimmedDrawerBackground(
        isShown: Bool,
        drawerState: DrawerState,
        drawerBottomPosition: DrawerBottomPosition,
        drawerMidPosition: DrawerMidPosition?,
        drawerTopPosition: DrawerTopPosition = .relativeToSafeAreaTop(offset: 0),
        positionCalculator: DrawerPositionCalculator
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
