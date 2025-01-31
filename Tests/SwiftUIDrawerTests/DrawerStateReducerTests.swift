import Testing
import UIKit
@testable import SwiftUIDrawer

@Suite("DrawerStateReducerTests")
struct DrawerStateReducerTests {
    static let dragHandleHeight = 12.0
    
    static let screenBoundsProvider = ScreenBoundsProvidingMock()
    static let safeAreaInsetsProvider = SafeAreaInsetsProvidingMock()
    static let tabBarFrameProvider = TabBarFrameProvidingMock()
    
    var screenBounds: CGRect { Self.screenBoundsProvider.bounds }
    var safeAreaInsets: UIEdgeInsets { Self.safeAreaInsetsProvider.insets }
    var tabBarFrame: CGRect { Self.tabBarFrameProvider.frame }
    
    let positionCalculator = DrawerPositionCalculator(
        screenBoundsProvider: Self.screenBoundsProvider,
        safeAreaInsetsProvider: Self.safeAreaInsetsProvider,
        tabBarFrameProvider: Self.tabBarFrameProvider,
        dragHandleHeight: Self.dragHandleHeight
    )
    
    func makeSubject(
        bottomPosition: DrawerBottomPosition,
        midPosition: DrawerMidPosition?,
        topPosition: DrawerTopPosition
    ) -> DrawerStateReducer {
        .init(
            bottomPosition: bottomPosition,
            topPosition: topPosition,
            midPosition: midPosition,
            positionCalculator: positionCalculator
        )
    }
    
    @Test("Test `onDrag` function sets `state.case` to `dragging` and keeps `state.currentPosition` between the absolute values of the `bottomPosition` and `topPosition`")
    func testOnDrag() {
        var drawerState = DrawerState(case: .closed)
        let bottomPosition = DrawerBottomPosition.relativeToSafeAreaBottom(offset: 50)
        let topPosition = DrawerTopPosition.relativeToSafeAreaTop(offset: 50)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        subject.onDrag(
            &drawerState,
            yTranslation: 10,
            lastYTranslation: 5
        )
        
        #expect(drawerState.isDragging)
        
        #expect(drawerState.currentPosition >= positionCalculator.absoluteValue(for: bottomPosition))
        
        #expect(drawerState.currentPosition <= positionCalculator.absoluteValue(for: topPosition))
    }
    
    // TODO: Finish tests
    @Test func testOnDraggingEnded() {
        
    }
    
    @Test(
        "Test if the `state.currentPosition` is correctly updated for the current `state.case`",
        arguments: [
            DrawerState(case: .dragging),
            .init(case: .closed),
            .init(case: .partiallyOpened),
            .init(case: .fullyOpened)
        ]
    ) func testSyncCaseAndCurrentPosition(of state: DrawerState) {
        var state = state
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let oldCurrentPosition = state.currentPosition
        subject.syncCaseAndCurrentPosition(of: &state)
        
        switch state.case {
        case .dragging:
            #expect(state.currentPosition == oldCurrentPosition)
        case .closed:
            #expect(state.currentPosition == positionCalculator.absoluteValue(for: bottomPosition))
        case .partiallyOpened:
            #expect(state.currentPosition == positionCalculator.absoluteValue(for: midPosition))
        case .fullyOpened:
            #expect(state.currentPosition == positionCalculator.absoluteValue(for: topPosition))
        }
    }
}
