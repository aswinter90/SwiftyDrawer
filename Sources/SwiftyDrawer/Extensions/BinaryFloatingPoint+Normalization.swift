import Foundation

/// Returns a normalized value for the range between `a` and `b`
/// - Parameters:
///   - min: minimum of the range of the measurement
///   - max: maximum of the range of the measurement
///   - a: minimum of the range of the scale
///   - b: minimum of the range of the scale
/// Kudos to https://gist.github.com/mcichecki/bf8808f123ce342b17058abcca3b5378
public extension BinaryFloatingPoint {
    // swiftlint:disable:next identifier_name
    func normalize(min: Self, max: Self, from a: Self = 0, to b: Self = 1) -> Self {
        (b - a) * ((self - min) / (max - min)) + a
    }
}
