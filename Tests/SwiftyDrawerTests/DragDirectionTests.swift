import Testing
import Foundation
@testable import SwiftyDrawer

@MainActor
@Suite("DragDirectionTests")
struct DragDirectionTests {
    @Test("Test `DragDirection` is `up` if startLocation.y is bigger than endLocation.y and the velocity is not too low")
    func testDragDirectionInitializerForUpCase() {
        let subject = DragDirection(
            startLocationY: 50.0,
            endLocationY: 30.0,
            velocity: DrawerConstants.draggingVelocityThreshold
        )

        #expect(subject == .up)
    }

    @Test("Test `DragDirection` is `down` if startLocation.y is smaller than endLocation.y and the velocity is not too low")
    func testDragDirectionInitializerForDownCase() {
        let subject = DragDirection(
            startLocationY: 30.0,
            endLocationY: 50.0,
            velocity: DrawerConstants.draggingVelocityThreshold
        )

        #expect(subject == .down)
    }

    @Test("Test `DragDirection` is `undefined` if the velocity is too low")
    func testDragDirectionInitializerForUndefinedCase() {
        let subject = DragDirection(
            startLocationY: 30.0,
            endLocationY: 50.0,
            velocity: DrawerConstants.draggingVelocityThreshold - 10
        )

        #expect(subject == .undefined)
    }
}
