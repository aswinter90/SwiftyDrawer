import Foundation
import SwiftUI

struct DimmingView: View {
    private static let maxOpacity = 0.4

    @Binding var drawerState: DrawerState
    @Binding var drawerBottomPosition: DrawerBottomPosition
    @Binding var drawerMidPosition: DrawerMidPosition?
    @Binding var drawerTopPosition: DrawerTopPosition

    var body: some View {
        Color.black
            .allowsHitTesting(false)
            .opacity(opacity)
            .animation(.linear(duration: 0.3), value: opacity)
    }

    private var opacity: CGFloat {
        let midPosition = if let drawerMidPosition = drawerMidPosition?.value {
            drawerMidPosition
        } else {
            (drawerBottomPosition.value + drawerTopPosition.value) / 2
        }

        let opacity = drawerState.currentHeight.normalize(
            min: midPosition,
            max: drawerTopPosition.value,
            from: 0,
            to: Self.maxOpacity
        )

        return max(0, opacity)
    }
}
