import XCTest
import SwiftyDrawer

/// The UI tests defined here serve as a playground for the author to catch up with the capabilities of XCUITests. In the long term they should probably be replaced with Snapshot tests (using the Point-Free framework, or similar)
final class SwiftyDrawer_DemoUITests: XCTestCase {
    private static let drawerSwipeDuration: UInt64 = 800_000_000
    private static let drawerPositionCheckAccuracy = 0.1
    private static let lastDrawerContentItemIdentifier = "Item 29"

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testDrawerPositionsAndContent() async throws {
        let app = XCUIApplication()
        app.launch()

        let drawer = app.otherElements.matching(identifier: "SwiftyDrawer").firstMatch
        XCTAssertTrue(drawer.exists)

        // Unfortunately there is no UIWindow instance available in XCTestCases to get the safe-area-insets from, hence the insets are injected as an accessibility label in the UI hierarchy of the drawer for now, which is not an elegant solution.
        let safeAreaInsets = try SafeAreaInsetsHolder(data: drawer.label.data(using: .utf8)!)

        // Check drawer top position

        await runAction(drawer.swipeUpFast())

        XCTAssertEqual(
            drawer.frame.origin.y,
            safeAreaInsets.top,
            accuracy: Self.drawerPositionCheckAccuracy
        )

        // Check drawer content by finding last item

        await runAction(drawer.swipeUpFast(), iterations: 3)

        let lastDrawerContentItem = app
            .staticTexts
            .matching(identifier: Self.lastDrawerContentItemIdentifier)
            .firstMatch

        XCTAssertTrue(lastDrawerContentItem.isHittable)

        // Check drawer mid position

        await runAction(drawer.swipeDownFast(), iterations: 4)

        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height
                - Double(safeAreaInsets.bottom)
                - TabBarFrameProvider.sharedInstance.frame.height
                - DrawerConstants.drawerDefaultMidPositionConstant
                - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )

        // Check drawer bottom position

        await runAction(drawer.swipeDownFast())

        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height - Double(safeAreaInsets.bottom) - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )
    }

    @MainActor
    private func runAction(
        _ action: @escaping @autoclosure () -> Void,
        iterations: Int = 1,
        sleepAfterAction nanoseconds: UInt64 = SwiftyDrawer_DemoUITests.drawerSwipeDuration
    ) async {
        for _ in 0 ..< iterations {
            action()

            try! await Task.sleep(nanoseconds: nanoseconds)
        }
    }
}

private extension XCUIElement {
    func swipeUpFast() {
        swipeUp(velocity: .fast)
    }

    func swipeDownFast() {
        swipeDown(velocity: .fast)
    }
}
