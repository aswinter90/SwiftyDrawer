import Foundation

public struct DrawerState {
    public enum Case {
        case closed
        case partiallyOpened
        case fullyOpened
    }

    public var `case`: Case
    public internal(set) var currentPosition: CGFloat = 0.0

    public init(case: Case) {
        self.case = `case`
    }
}
