import SwiftUI

extension View {
    @ViewBuilder
    func hapticFeedback<Trigger: Equatable>(trigger: Trigger, isEnabled: Bool) -> some View {
        if #available(iOS 17.0, *), isEnabled {
            sensoryFeedback(.impact, trigger: trigger)
        } else {
            self
        }
    }
}
