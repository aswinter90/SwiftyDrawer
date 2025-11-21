import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(condition: Bool, content: @escaping (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
