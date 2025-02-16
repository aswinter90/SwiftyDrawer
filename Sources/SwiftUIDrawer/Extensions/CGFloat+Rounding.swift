import Foundation

public extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        let rounded = Darwin.round(self * multiplier) / multiplier
        return rounded
    }
}

public extension CGFloat {
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        Double(self).roundToDecimal(fractionDigits)
    }
}
