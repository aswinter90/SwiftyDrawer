import CoreGraphics

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
