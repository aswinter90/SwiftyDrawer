import Foundation
import SwiftUI

public final class DrawerFloatingButtons: Sendable {
    public struct ButtonConfiguration: Sendable {
        let icon: Image
        let action: @Sendable @MainActor () -> Void

        public init(icon: Image, action: @escaping @Sendable @MainActor () -> Void) {
            self.icon = icon
            self.action = action
        }
    }

    let firstConfiguration: ButtonConfiguration?
    let secondConfiguration: ButtonConfiguration?

    var isEmpty: Bool {
        firstConfiguration == nil && secondConfiguration == nil
    }

    public init(firstConfiguration: ButtonConfiguration?, secondConfiguration: ButtonConfiguration? = nil) {
        self.firstConfiguration = firstConfiguration
        self.secondConfiguration = secondConfiguration
    }
}
