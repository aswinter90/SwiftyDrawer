import Testing
import CoreGraphics
@testable import SwiftyDrawer

@Suite("DrawerTopPositionTests")
struct DrawerTopPositionTests {
    private static let expectedAssociatedValue: Double = 10.0

    private static let allCases: [DrawerTopPosition] = [
        .absolute(Self.expectedAssociatedValue),
        .relativeToSafeAreaTop(offset: Self.expectedAssociatedValue)
    ]

    @Test(
        "Associated values match expected value",
        arguments: allCases
    ) func testAssociatedValues(subject: DrawerTopPosition) async throws {
        switch subject {
        case .absolute(let double):
            #expect(double == Self.expectedAssociatedValue)
        case .relativeToSafeAreaTop(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        }
    }
}
