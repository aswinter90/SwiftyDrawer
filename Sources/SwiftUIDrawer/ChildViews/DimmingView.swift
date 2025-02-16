import Foundation
import SwiftUI

struct DimmingView: View {
    private static let maxOpacity = 0.4

    let drawerState: DrawerState
    let drawerBottomPosition: DrawerBottomPosition
    let drawerMidPosition: DrawerMidPosition?
    let drawerTopPosition: DrawerTopPosition
    let positionCalculator: DrawerPositionCalculator
    
    var body: some View {
        Color.black
            .allowsHitTesting(false)
            .opacity(opacity)
            .animation(.linear(duration: 0.3), value: opacity)
    }

    private var opacity: Double {
        let topPosition = positionCalculator.absoluteValue(for: drawerTopPosition)
        
        let midPosition = if let drawerMidPosition {
            positionCalculator.absoluteValue(for: drawerMidPosition)
        } else {
            (positionCalculator.absoluteValue(for: drawerBottomPosition) + topPosition) / 2
        }

        let opacity = drawerState.currentPosition.normalize(
            min: midPosition,
            max: topPosition,
            from: 0,
            to: Self.maxOpacity
        )

        return max(0, opacity)
    }
}
