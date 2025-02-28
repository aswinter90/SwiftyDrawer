import CoreGraphics

/// After passing this controller as an environment object to the drawer through the `drawerContentOffsetController(_ controller:)` function,
/// you can use it to observe or update the scroll offset of the content inside the drawer.
public final class DrawerContentOffsetController {
    public init() {}

    private var contentOffset: CGPoint?

    public func updateContentOffset(_ offset: CGPoint) {
        contentOffset = offset
    }

    @discardableResult
    func consumeLatestContentOffset() -> CGPoint? {
        guard let contentOffset else { return nil }

        self.contentOffset = nil
        return contentOffset
    }
}
