import Testing
import UIKit
@testable import SwiftUIDrawer

@Suite("DrawerStateReducerTests")
struct DrawerStateReducerTests {
    static let screenBounds = CGRect(x: 0, y: 0, width: 1080, height: 1920)
    static let dragHandleHeight = 12.0
    static let unsufficientDragVelocity = DrawerConstants.draggingVelocityThreshold - 1
    static let safeAreaInsetsProvider = SafeAreaInsetsProvidingMock()
    static let tabBarFrameProvider = TabBarFrameProvidingMock()
    
    var safeAreaInsets: UIEdgeInsets { Self.safeAreaInsetsProvider.insets }
    var tabBarFrame: CGRect { Self.tabBarFrameProvider.frame }
    
    let positionCalculator = DrawerPositionCalculator(
        screenBounds: Self.screenBounds,
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
    
    @Test("Test `onDraggingEnded` when the user dragged up with a high enough velocity to invoke a state change to `partiallyOpened` and a `DrawerMidPosition` is provided")
    func testOnDraggingEnded1() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: DrawerConstants.draggingVelocityThreshold)
        )
        
        #expect(state.case == .partiallyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a high enough velocity to invoke a state change to `closed` and a `DrawerMidPosition` is provided")
    func testOnDraggingEnded2() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: DrawerConstants.draggingVelocityThreshold)
        )
        
        #expect(state.case == .closed)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged up with a velocity too low to invoke a clear state change and a `DrawerMidPosition` is provided and `DrawerBottomPosition` is the nearest fixed position")
    func testOnDraggingEnded3() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .closed)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged up with a velocity too low to invoke a clear state change and a `DrawerMidPosition` is provided and `DrawerMidPosition` is the nearest fixed position")
    func testOnDraggingEnded4() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 200.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: 1)
        )
        
        #expect(state.case == .partiallyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged up with a high enough velocity to invoke a state change to `fullyOpened` and no `DrawerMidPosition` is provided")
    func testOnDraggingEnded5() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: DrawerConstants.draggingVelocityThreshold)
        )
        
        #expect(state.case == .fullyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a high enough velocity to invoke a state change to `closed` and no `DrawerMidPosition` is provided")
    func testOnDraggingEnded6() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: DrawerConstants.draggingVelocityThreshold)
        )
        
        #expect(state.case == .closed)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged up with a velocity too low to invoke a clear state change and no `DrawerMidPosition` is provided and `DrawerBottomPosition` is the nearest fixed position")
    func testOnDraggingEnded7() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .closed)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged up with a velocity too low to invoke a clear state change and no `DrawerMidPosition` is provided and `DrawerTopPosition` is the nearest fixed position")
    func testOnDraggingEnded8() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 450.0
        let startLocation = CGPoint(x: 0, y: y)
        let endLocation = CGPoint(x: 0, y: 0)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .fullyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a velocity too low to invoke a clear state change and a `DrawerMidPosition` is provided and `DrawerTopPosition` is the nearest fixed position")
    func testOnDraggingEnded9() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 450.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .fullyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a velocity too low to invoke a clear state change and no `DrawerMidPosition` is provided and `DrawerTopPosition` is the nearest fixed position")
    func testOnDraggingEnded10() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 450.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .fullyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a velocity too low to invoke a clear state change and a `DrawerMidPosition` is provided and `DrawerMidPosition` is the nearest fixed position")
    func testOnDraggingEnded11() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 300.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .partiallyOpened)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a velocity too low to invoke a clear state change and a `DrawerMidPosition` is provided and `DrawerBottomPosition` is the nearest fixed position")
    func testOnDraggingEnded12() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let midPosition = DrawerMidPosition.absolute(250)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: midPosition,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .closed)
    }
    
    @Test("Test `onDraggingEnded` when the user dragged down with a velocity too low to invoke a clear state change and no `DrawerMidPosition` is provided and `DrawerBottomPosition` is the nearest fixed position")
    func testOnDraggingEnded13() {
        var state = DrawerState(case: .dragging)
        
        let bottomPosition = DrawerBottomPosition.absolute(0)
        let topPosition = DrawerTopPosition.absolute(500)
        
        let subject = makeSubject(
            bottomPosition: bottomPosition,
            midPosition: nil,
            topPosition: topPosition
        )
        
        let y = 50.0
        let startLocation = CGPoint(x: 0, y: 0)
        let endLocation = CGPoint(x: 0, y: y)
        
        state.currentPosition = y
        
        subject.onDraggingEnded(
            &state,
            startLocation: startLocation,
            endLocation: endLocation,
            velocity: .init(width: 0, height: Self.unsufficientDragVelocity)
        )
        
        #expect(state.case == .closed)
    }
}
