import Foundation

struct DrawerStateReducer {
    private let bottomPosition: DrawerBottomPosition
    private let topPosition: DrawerTopPosition
    private let midPosition: DrawerMidPosition?
    private let positionCalculator: DrawerPositionCalculator
    
    init(
        bottomPosition: DrawerBottomPosition,
        topPosition: DrawerTopPosition,
        midPosition: DrawerMidPosition?,
        positionCalculator: DrawerPositionCalculator
    ) {
        self.bottomPosition = bottomPosition
        self.topPosition = topPosition
        self.midPosition = midPosition
        self.positionCalculator = positionCalculator
    }
    
    func updateStateOnDraggingEnd(
        _ state: inout DrawerState,
        draggingStartLocation: CGPoint,
        draggingEndLocation: CGPoint,
        velocity: CGSize
    ) {
        let startLocation = draggingStartLocation.y.roundToDecimal(3)
        let endlocation = draggingEndLocation.y.roundToDecimal(3)
        
        let targetDirection = DragTargetDirection(
            startLocationY: startLocation,
            endLocationY: endlocation,
            velocity: velocity.height
        )

        switch (state.case, targetDirection) {
        case (.closed, .down):
            state.case = .closed
        case (.closed, .up):
            state.case = midPosition != nil ? .partiallyOpened : .fullyOpened
        case (.partiallyOpened, .down):
            state.case = .closed
        case (.partiallyOpened, .up):
            state.case = .fullyOpened
        case (.fullyOpened, .down):
            state.case = midPosition != nil ? .partiallyOpened : .closed
        case (.fullyOpened, .up):
            state.case = .fullyOpened
        case (_, .undefined):
            // Gesture was too slow or the translation was too small. Find the nearest fixed drawer position
            let offsetToBottomPosition = abs(
                state.currentPosition - positionCalculator.absoluteValue(for: bottomPosition)
            )

            var offsetToMidPosition: CGFloat
            
            if let midPosition = midPosition {
                let midPositionValue = positionCalculator.absoluteValue(for: midPosition)
                
                offsetToMidPosition = abs(
                    max(state.currentPosition, midPositionValue) - min(state.currentPosition, midPositionValue)
                )
            } else {
                offsetToMidPosition = CGFloat.infinity // Eliminates `offsetToMidPosition` from the following switch
            }

            let offsetToTopPosition = abs(positionCalculator.absoluteValue(for: topPosition) - state.currentPosition)

            switch min(offsetToBottomPosition, offsetToMidPosition, offsetToTopPosition) {
            case offsetToBottomPosition:
                state.case = .closed
            case offsetToMidPosition:
                state.case = .partiallyOpened
            case offsetToTopPosition:
                state.case = .fullyOpened
            default:
                // Unexpected case
                break
            }
            
            updateCurrentPosition(of: &state)
        }
    }
    
    func updateCurrentPosition(of state: inout DrawerState) {
        switch state.case {
        case .closed:
            state.currentPosition = positionCalculator.absoluteValue(for: bottomPosition)
        case .partiallyOpened:
            if let midPosition = midPosition {
                state.currentPosition = positionCalculator.absoluteValue(for: midPosition)
            } else {
                assertionFailure("Cannot set drawer state to `partiallyOpened` when no midPosition was defined")
            }
        case .fullyOpened:
            state.currentPosition = positionCalculator.absoluteValue(for: topPosition)
        }
    }
}
