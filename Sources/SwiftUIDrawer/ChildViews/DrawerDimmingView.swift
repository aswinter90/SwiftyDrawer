import Foundation
import SwiftUI

struct DrawerDimmingView: View {
    private static let maxOpacity = 0.4

    @Binding var drawerState: DrawerState
    @Binding var drawerMinHeight: DrawerMinHeight
    @Binding var drawerMediumHeight: DrawerMediumHeight?
    @Binding var drawerMaxHeight: DrawerMaxHeight

    var body: some View {
        Color.black
            .allowsHitTesting(false)
            .opacity(opacity)
            .animation(.linear(duration: 0.3), value: opacity)
    }

    private var opacity: CGFloat {
        let mediumHeight = if let drawerMediumHeight = drawerMediumHeight?.absoluteValue {
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
