import Foundation
import SwiftUI

public final class DrawerFloatingButtonsConfiguration: Sendable {
    public struct ButtonProperties: Sendable, Identifiable {
        public let id = UUID().uuidString
        let icon: Image
        let action: @Sendable @MainActor () -> Void

        public init(icon: Image, action: @escaping @Sendable @MainActor () -> Void) {
            self.icon = icon
            self.action = action
        }
    }

    let leadingButtons: [ButtonProperties]
    let trailingButtons: [ButtonProperties]

    var isEmpty: Bool {
        leadingButtons.isEmpty && trailingButtons.isEmpty
    }

    public init(
        leadingButtons: [ButtonProperties] = [],
        trailingButtons: [ButtonProperties] = []
    ) {
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
    }
}
