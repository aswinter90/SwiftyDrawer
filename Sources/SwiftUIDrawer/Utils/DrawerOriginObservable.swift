import Foundation

public final class DrawerOriginObservable {
    @Published public var origin: CGPoint?

    public init() {}

    func update(origin: CGPoint) {
        self.origin = origin
    }
}
