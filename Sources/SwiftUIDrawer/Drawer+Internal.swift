import SwiftUI
import UIKit

extension Drawer {
    enum DragTargetDirection {
        case up
        case down
        case undefined

        init(startLocationY: CGFloat, endLocationY: CGFloat, velocity: CGFloat) {
            let isSlowGesture = abs(velocity) < DrawerConstants.draggingVelocityThreshold

            if isSlowGesture {
                self = .undefined
            } else {
                self = endLocationY > startLocationY ? .down : .up
            }
        }
    }

    /// Used for interpolating values of the drawer position during animations.
    struct OffsetEffect: GeometryEffect {
        var value: CGFloat
        var onValueDidChange: (CGFloat) -> Void

        var animatableData: CGFloat {
            get { value }
            set { value = newValue }
        }

        func effectValue(size _: CGSize) -> ProjectionTransform {
            onValueDidChange(value)
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: value))
        }
    }
}
