import Foundation

/// This publishes the origin of the drawer to the outside-world. The difference to the `currentPosition` property of the `DrawerState` is, that this class also updates during drawer animations.
public final class DrawerOriginObservable {
    @Published public var origin: CGPoint?

    public init() {}

    func updateIfNeeded(origin: CGPoint) {
        guard self.origin != origin else { return }

        self.origin = origin
    }
}
