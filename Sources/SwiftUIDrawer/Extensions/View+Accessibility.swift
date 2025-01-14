import SwiftUI

extension View {
    func storeSafeAreaInsetsAsAccessibilityLabel() -> some View {
        let topInset = UIApplication.shared.safeAreaInsets.top
        let bottomInset = UIApplication.shared.safeAreaInsets.bottom
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .decimal
        
        let formattedTopInset = numberFormatter.string(from: NSNumber(value: topInset)) ?? ""
        let formattedBottomInset = numberFormatter.string(from: NSNumber(value: bottomInset)) ?? ""

        return accessibilityLabel(
            #"{"safeAreaTop\": \#(formattedTopInset), "safeAreaBottom\": \#(formattedBottomInset)}"#
        )
    }
}
