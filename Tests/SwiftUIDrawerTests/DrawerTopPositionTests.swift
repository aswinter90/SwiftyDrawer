import Testing
import CoreGraphics
@testable import SwiftUIDrawer

@Suite("DrawerTopPositionTests")
struct DrawerTopPositionTests {
    private static let expectedAssociatedValue: CGFloat = 10.0
    
    private static let allCases: [DrawerTopPosition] = [
        .absolute(Self.expectedAssociatedValue),
        .relativeToSafeAreaTop(offset: Self.expectedAssociatedValue)
    ]
    
    @Test(
        "Associated values match expected value",
        arguments: allCases
    ) func testAssociatedValues(subject: DrawerTopPosition) async throws {
        switch subject {
        case .absolute(let cGFloat):
            #expect(cGFloat == Self.expectedAssociatedValue)
        case .relativeToSafeAreaTop(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        }
    }
}
