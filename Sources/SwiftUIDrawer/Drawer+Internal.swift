import SwiftUI
import UIKit

extension Drawer {
    /// Used for interpolating values of the drawer position during animations.
    struct OffsetEffect: GeometryEffect {
        var value: Double
        var onValueDidChange: (Double) -> Void

        var animatableData: Double {
            get { value }
            set { value = newValue }
        }

        func effectValue(size _: CGSize) -> ProjectionTransform {
            onValueDidChange(value)
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: value))
        }
    }
}
