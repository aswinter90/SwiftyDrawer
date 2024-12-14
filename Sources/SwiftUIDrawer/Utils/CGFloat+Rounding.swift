import Foundation

public extension CGFloat {
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        let multiplier = pow(10, CGFloat(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
