import Foundation
import SwiftUI

public final class DrawerFloatingButtonsConfiguration: Sendable {
    public struct ButtonProperties: Sendable {
        let icon: Image
        let action: @Sendable @MainActor () -> Void

        public init(icon: Image, action: @escaping @Sendable @MainActor () -> Void) {
            self.icon = icon
            self.action = action
        }
    }

    let firstButtonProperties: ButtonProperties?
    let secondButtonProperties: ButtonProperties?

    var isEmpty: Bool {
        firstButtonProperties == nil && secondButtonProperties == nil
    }

    public init(firstButtonProperties: ButtonProperties?, secondButtonProperties: ButtonProperties? = nil) {
        self.firstButtonProperties = firstButtonProperties
        self.secondButtonProperties = secondButtonProperties
    }
}
