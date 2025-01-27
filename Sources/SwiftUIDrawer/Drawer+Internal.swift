import SwiftUI
import UIKit

extension Drawer {
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
