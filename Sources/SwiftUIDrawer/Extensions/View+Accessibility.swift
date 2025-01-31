import SwiftUI

private enum Formatters {
    static let safeAreaInsetsNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
}

extension View {
    func storeSafeAreaInsetsAsAccessibilityLabel(_ insets: UIEdgeInsets) -> some View {
        let formattedTopInset = Formatters.safeAreaInsetsNumberFormatter.string(from: NSNumber(value: insets.top)) ?? ""
        let formattedBottomInset = Formatters.safeAreaInsetsNumberFormatter.string(from: NSNumber(value: insets.bottom)) ?? ""

        return accessibilityLabel(
            #"{"safeAreaTop\": \#(formattedTopInset), "safeAreaBottom\": \#(formattedBottomInset)}"#
        )
    }
}
