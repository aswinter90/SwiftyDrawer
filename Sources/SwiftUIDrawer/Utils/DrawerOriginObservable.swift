import Foundation

public final class DrawerOriginObservable {
    @Published public var origin: CGPoint?

    public init() {}

    func change(origin: CGPoint) {
        self.origin = origin
    }
}
