import Foundation
import SwiftUI

private struct DimmingView: View {
    private static let maxOpacity = 0.4

    @Binding var drawerState: DrawerState
    @Binding var drawerMinHeight: DrawerMinHeight
    let drawerMediumHeight: Binding<DrawerMediumHeight>?
    let drawerMaxHeight: DrawerMaxHeight

    var body: some View {
        Color.black
            .allowsHitTesting(false)
            .opacity(opacity)
            .animation(.linear(duration: 0.3), value: opacity)
    }

    private var opacity: CGFloat {
        let mediumHeight = if let drawerMediumHeight = drawerMediumHeight?.wrappedValue.absoluteValue {
            drawerMediumHeight
        } else {
            (drawerMinHeight.absoluteValue + drawerMaxHeight.absoluteValue) / 2
        }

        let opacity = drawerState.currentHeight.normalize(
            min: mediumHeight,
            max: drawerMaxHeight.absoluteValue,
            from: 0,
            to: Self.maxOpacity
        )

        return max(0, opacity)
    }
}

extension View {
    @ViewBuilder
    func dimmingOverlay(
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
