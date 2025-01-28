import Testing
import CoreGraphics
@testable import SwiftUIDrawer

@Suite("DrawerMidPositionTests") struct DrawerMidPositionTests {
    private static let expectedAssociatedValue: CGFloat = 10.0
    
    private static let allCases: [DrawerMidPosition] = [
        .absolute(Self.expectedAssociatedValue),
        .relativeToSafeAreaBottom(offset: Self.expectedAssociatedValue),
        .relativeToTabBar(offset: Self.expectedAssociatedValue)
    ]
    
    @Test(
        "Associated values match expected value",
        arguments: allCases
    ) func testAssociatedValues(subject: DrawerMidPosition) async throws {
        switch subject {
        case .absolute(let cGFloat):
            #expect(cGFloat == Self.expectedAssociatedValue)
        case .relativeToSafeAreaBottom(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        case .relativeToTabBar(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        }
    }
}
