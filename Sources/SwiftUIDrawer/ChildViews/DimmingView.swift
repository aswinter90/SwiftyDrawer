import Foundation
import SwiftUI

struct DimmingView: View {
    private static let maxOpacity = 0.4

    @Binding var drawerState: DrawerState
    @Binding var drawerBottomPosition: DrawerBottomPosition
    @Binding var drawerMidPosition: DrawerMidPosition?
    @Binding var drawerTopPosition: DrawerTopPosition
    private let positionCalculator: DrawerPositionCalculator

    init(
        drawerState: Binding<DrawerState>,
        drawerBottomPosition: Binding<DrawerBottomPosition>,
        drawerMidPosition: Binding<DrawerMidPosition?>?,
        drawerTopPosition: Binding<DrawerTopPosition>,
        positionCalculator: DrawerPositionCalculator
    ) {
        _drawerState = drawerState
        _drawerBottomPosition = drawerBottomPosition
        _drawerMidPosition = drawerMidPosition ?? .constant(nil)
        _drawerTopPosition = drawerTopPosition
        self.positionCalculator = positionCalculator
    }
    
    var body: some View {
        Color.black
            .allowsHitTesting(false)
            .opacity(opacity)
//            .animation(.linear(duration: 0.3), value: opacity) // TODO: Still needed?
    }

    private var opacity: CGFloat {
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
