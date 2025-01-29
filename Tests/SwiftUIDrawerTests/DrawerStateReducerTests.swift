import Testing
import Foundation
@testable import SwiftUIDrawer

@Suite("DrawerStateReducerTests")
struct DrawerStateReducerTests {
    static let dragHandleHeight = 12.0
    let screenBoundsProvider = ScreenBoundsProvidingMock()
    let safeAreaInsetsProvider = SafeAreaInsetsProvidingMock()
    let tabBarFrameProvider = TabBarFrameProvidingMock()
    
    func makeSubject(
        bottomPosition: DrawerBottomPosition,
        midPosition: DrawerMidPosition,
        topPosition: DrawerTopPosition
    ) -> DrawerStateReducer {
        .init(
            bottomPosition: bottomPosition,
            topPosition: topPosition,
            midPosition: midPosition,
            positionCalculator: .init(
                screenBoundsProvider: screenBoundsProvider,
                safeAreaInsetsProvider: safeAreaInsetsProvider,
                tabBarFrameProvider: tabBarFrameProvider,
                dragHandleHeight: Self.dragHandleHeight
            )
        )
    }
    
    @Test func testUpdateStateOnDraggingEnded() {
        
    }
}
