import SwiftUI

extension EdgeInsets: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(trailing)
        hasher.combine(bottom)
        hasher.combine(leading)
    }
}
