import SwiftUI

public struct DrawerVerticallyCenteredContentContainerView<Content: View>: View {
    @Environment(\.mediumDrawerContentHeight) private var mediumDrawerContentHeight: CGFloat
    @Environment(\.drawerStickyHeaderHeight) private var drawerStickyHeaderHeight: CGFloat
    @State private var height: CGFloat?

    let content: Content

    public init(content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            content
        }
        .readFrame(in: .local, onChange: { frame in
            height = frame.size.height
        })
        .padding(.top, (mediumDrawerContentHeight - drawerStickyHeaderHeight) / 2 - (height ?? 0) / 2)
    }
}
