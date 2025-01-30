import Foundation

enum DragDirection {
    case up
    case down
    case undefined
    
    init(startLocationY: CGFloat, endLocationY: CGFloat, velocity: CGFloat) {
        let isSlowGesture = abs(velocity) < DrawerConstants.draggingVelocityThreshold
        
        if isSlowGesture {
            self = .undefined
        } else {
            self = endLocationY > startLocationY ? .down : .up
        }
    }
}
