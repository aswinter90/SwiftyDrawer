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
    
    func onDrag(
        _ state: inout DrawerState,
        yTranslation: Double,
        lastYTranslation: Double
    ) {
        state.case = .dragging

        let newPosition = state.currentPosition - (yTranslation - lastYTranslation)
        
        state.currentPosition = max(
            positionCalculator.absoluteValue(for: bottomPosition),
            min(positionCalculator.absoluteValue(for: topPosition), newPosition)
        )
    }
    
    func onDraggingEnded(
        _ state: inout DrawerState,
        startLocation: CGPoint,
        endLocation: CGPoint,
        velocity: CGSize
    ) {
        let startLocation = startLocation.y.roundToDecimal(3)
        let endlocation = endLocation.y.roundToDecimal(3)
        
        let targetDirection = DragDirection(
            startLocationY: startLocation,
            endLocationY: endlocation,
            velocity: velocity.height
        )

        let currentPosition = state.currentPosition
        let absoluteMidPosition = midPosition.map {
            positionCalculator.absoluteValue(for: $0)
        }
        
        switch targetDirection {
        case .up:
            if let absoluteMidPosition, currentPosition < absoluteMidPosition {
                state.case = .partiallyOpened
            } else {
                state.case = .fullyOpened
            }
        case .down:
            if let absoluteMidPosition, currentPosition > absoluteMidPosition {
                state.case = .partiallyOpened
            } else {
                state.case = .closed
            }
        case .undefined:
            // The gesture was too slow or the translation was too small. The user likely let go of the drawer between two fixed positions. Find the nearest fixed position.
            let offsetToBottomPosition = abs(
                state.currentPosition - positionCalculator.absoluteValue(for: bottomPosition)
            )

            var offsetToMidPosition: Double
            
            if let midPosition = midPosition {
                let midPositionValue = positionCalculator.absoluteValue(for: midPosition)
                
                offsetToMidPosition = abs(
                    max(state.currentPosition, midPositionValue) - min(state.currentPosition, midPositionValue)
                )
            } else {
                offsetToMidPosition = Double.infinity // Eliminates `offsetToMidPosition` from the following switch
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
        }
    }
    
    func syncCaseAndCurrentPosition(of state: inout DrawerState) {
        switch state.case {
        case .dragging:
            break
        case .closed:
            state.currentPosition = positionCalculator.absoluteValue(for: bottomPosition)
        case .partiallyOpened:
            if let midPosition = midPosition {
                state.currentPosition = positionCalculator.absoluteValue(for: midPosition)
            } else {
                assertionFailure("Cannot set `state.currentPosition` to value for `partiallyOpened` case when no `midPosition` was defined")
            }
        case .fullyOpened:
            state.currentPosition = positionCalculator.absoluteValue(for: topPosition)
        }
    }
}
