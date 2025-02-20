import SwiftUI

struct ViewDidAppearFirst: ViewModifier {
    @State private var didAppear = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if !didAppear {
                action?()
                didAppear = true
            }
        }
    }
}

public extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidAppearFirst(perform: action))
    }
}
