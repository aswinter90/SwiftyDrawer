import SwiftUI

public extension Color {
    static var background: Color {
        UIColor(
            darkMode: .init(hex: "#131821"),
            lightMode: .white
        )
        .toColor()
    }
    static var border: Color {
        UIColor(
            darkMode: .init(hex: "#3c414b"),
            lightMode: .init(hex: "#d7dce1")
        )
        .toColor()
    }
}

extension UIColor {
    convenience init(darkMode: UIColor, lightMode: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: darkMode
            default: lightMode
            }
        }
    }
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var opacity: Double = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            fatalError("Could not create Color from hex value \(hex)")
        }

        if length == 6 {
            red = Double((rgb & 0xFF0000) >> 16) / 255.0
            green = Double((rgb & 0x00FF00) >> 8) / 255.0
            blue = Double(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            red = Double((rgb & 0xFF00_0000) >> 24) / 255.0
            green = Double((rgb & 0x00FF_0000) >> 16) / 255.0
            blue = Double((rgb & 0x0000_FF00) >> 8) / 255.0
            opacity = Double(rgb & 0x0000_00FF) / 255.0
        } else {
            fatalError("Could not create Color from hex value \(hex)")
        }
        
        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }
    
    func toColor() -> Color {
        Color(uiColor: self)
    }
}
