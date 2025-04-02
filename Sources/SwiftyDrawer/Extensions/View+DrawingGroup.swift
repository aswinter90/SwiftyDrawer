import SwiftUI

extension View {
    @ViewBuilder
    func drawingGroup(
        isEnabled: Bool,
        opaque: Bool = false,
        colorMode: ColorRenderingMode = .nonLinear
    ) -> some View {
        if isEnabled {
            self.drawingGroup(opaque: opaque, colorMode: colorMode)
        } else {
            self
        }
    }
}
