import SwiftUI

/// This view can be used as a wrapper for `Drawer` content, which must not be laid out from the top but should be centered vertically when the drawer is in its `partiallyOpened` state.
public struct DrawerVerticallyCenteredContentContainerView<Content: View>: View {
    @Environment(\.drawerPartiallyOpenedStateContentContainerHeight) private var drawerPartiallyOpenedStateContentContainerHeight: Double
    @Environment(\.drawerStickyHeaderHeight) private var drawerStickyHeaderHeight: Double
    @State private var height: Double?

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
        .padding(.top, paddingTop)
    }

    private var paddingTop: Double {
        (drawerPartiallyOpenedStateContentContainerHeight - drawerStickyHeaderHeight) / 2 - (height ?? 0) / 2
    }
}
