import Testing
import CoreGraphics
@testable import SwiftUIDrawer

@Suite("DrawerBottomPositionTests")
struct DrawerBottomPositionTests {
    private static let expectedAssociatedValue: CGFloat = 10.0
    
    private static let allCases: [DrawerBottomPosition] = [
        .absolute(expectedAssociatedValue),
        .relativeToSafeAreaBottom(offset: expectedAssociatedValue),
        .relativeToTabBar(offset: expectedAssociatedValue),
        .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(stickyHeaderHeight: expectedAssociatedValue),
        .matchesStickyHeaderContentHeightAlignedToTabBar(stickyHeaderHeight: expectedAssociatedValue)
    ]
    
    @Test(
        "Associated values match expected value",
        arguments: allCases
    ) func testAssociatedValues(subject: DrawerBottomPosition) async throws {
        switch subject {
        case .absolute(let cGFloat):
            #expect(cGFloat == Self.expectedAssociatedValue)
        case .relativeToSafeAreaBottom(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        case .relativeToTabBar(let offset):
            #expect(offset == Self.expectedAssociatedValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == Self.expectedAssociatedValue)
        case .matchesStickyHeaderContentHeightAlignedToTabBar(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == Self.expectedAssociatedValue)
        }
    }
    
    @Test(
        "Returned value of `shouldMatchStickyHeaderHeight` property is correct",
        arguments: allCases
    ) func testShouldMatchStickyHeaderHeightProperty(subject: DrawerBottomPosition) {
        switch subject {
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom, .matchesStickyHeaderContentHeightAlignedToTabBar:
            #expect(subject.shouldMatchStickyHeaderHeight == true)
        default:
            #expect(subject.shouldMatchStickyHeaderHeight == false)
        }
    }
    
    @Test(
        "Returned value of `isAlignedToTabBar` property is correct",
        arguments: allCases
    ) func testIsAlignedToTabBarProperty(subject: DrawerBottomPosition) {
        switch subject {
        case .relativeToTabBar, .matchesStickyHeaderContentHeightAlignedToTabBar:
            #expect(subject.isAlignedToTabBar == true)
        default:
            #expect(subject.isAlignedToTabBar == false)
        }
    }
    
    @Test(
        "Associated value is correctly mutated after calling `updateAssociatedValueOfCurrentCase` function",
        arguments: allCases
    ) func testUpdateAssociatedValueOfCurrentCase(subject: DrawerBottomPosition) {
        let newValue: CGFloat = 20.0

        var updatedSubject = subject
        updatedSubject.updateAssociatedValueOfCurrentCase(newValue)
        
        switch updatedSubject {
        case .absolute(let cGFloat):
            #expect(cGFloat == newValue)
        case .relativeToSafeAreaBottom(let offset):
            #expect(offset == newValue)
        case .relativeToTabBar(let offset):
            #expect(offset == newValue)
        case .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == newValue)
        case .matchesStickyHeaderContentHeightAlignedToTabBar(let stickyHeaderHeight):
            #expect(stickyHeaderHeight == newValue)
        }
    }
}
