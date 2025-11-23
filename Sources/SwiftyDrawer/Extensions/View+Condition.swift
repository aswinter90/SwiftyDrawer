import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: @escaping (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
