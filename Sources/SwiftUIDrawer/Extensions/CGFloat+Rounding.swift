import Foundation

public extension CGFloat {
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        let multiplier = pow(10, CGFloat(fractionDigits))
        let rounded = Darwin.round(self * multiplier) / multiplier
        return rounded
    }
}
