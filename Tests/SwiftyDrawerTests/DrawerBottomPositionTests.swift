import Testing
import CoreGraphics
@testable import SwiftyDrawer

@Suite("DrawerBottomPositionTests")
struct DrawerBottomPositionTests {
    private static let expectedAssociatedValue: Double = 10.0

    private static let allCases: [DrawerBottomPosition] = [
        .absolute(expectedAssociatedValue),
        .relativeToSafeAreaBottom(offset: expectedAssociatedValue),
        .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: expectedAssociatedValue),
    ]

    @MainActor
    @Test(
        "Associated values match expected value",
        arguments: allCases
    ) func testAssociatedValues(subject: DrawerBottomPosition) async throws {
        switch subject {
        case .absolute(let double):
            #expect(double == Self.expectedAssociatedValue)
        case .relativeToSafeAreaBottom(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == Self.expectedAssociatedValue)
        }
    }

    @MainActor
    @Test(
        "Returned value of `shouldMatchStickyHeaderHeight` property is correct",
        arguments: allCases
    ) func testShouldMatchStickyHeaderHeightProperty(subject: DrawerBottomPosition) {
        switch subject {
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom:
            #expect(subject.shouldMatchStickyHeaderHeight == true)
        default:
            #expect(subject.shouldMatchStickyHeaderHeight == false)
        }
    }

    @MainActor
    @Test(
        "Associated value is correctly mutated after calling `updateAssociatedValueOfCurrentCase` function",
        arguments: allCases
    ) func testUpdateAssociatedValueOfCurrentCase(subject: DrawerBottomPosition) {
        let newValue: Double = 20.0

        var updatedSubject = subject
        updatedSubject.updateAssociatedValueOfCurrentCase(newValue)

        switch updatedSubject {
        case .absolute(let double):
            #expect(double == newValue)
        case .relativeToSafeAreaBottom(let offset):
            #expect(offset == newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == newValue)
        }
    }
}
