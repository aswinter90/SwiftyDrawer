import Foundation

public final class DrawerOriginObservable {
    @Published public var origin: CGPoint?

    public init() {}

    func updateIfNeeded(origin: CGPoint) {
        guard self.origin != origin else { return }
        
        self.origin = origin
    }
}
