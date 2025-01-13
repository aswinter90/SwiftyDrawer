import XCTest
import SwiftUIDrawer

/// The UI tests defined here serve as a playground for the author to catch up with the capabilities of XCUITests. In the long term they should probably be replaced with Snapshot tests (using the Point-Free framework, or similar)
final class SwiftUIDrawer_DemoUITests: XCTestCase {

    private static let drawerSwipeDuration: UInt64 = 800_000_000
    private static let drawerPositionCheckAccuracy = 0.1
    private static let lastDrawerContentItemIdentifier = "Item 29"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testDrawerPositionsAndContent() async throws {
        let app = XCUIApplication()
        app.launch()
        
        let drawer = app.otherElements.matching(identifier: "SwiftUIDrawer").firstMatch
        XCTAssertTrue(drawer.exists)

        // Unfortunately there is no UIWindow instance available in XCTestCases to grab the safe area insets from, hence the insets are injected as an accessibility label from the UI hierarchy. Which is rather a hack, but... 🙄
        let safeAreaInsets = try SafeAreaInsetsHolder(data: drawer.label.data(using: .utf8)!)
        
        // Check drawer top position
        
        await runAction(drawer.swipeUpFast())

        XCTAssertEqual(
            drawer.frame.origin.y,
            safeAreaInsets.top,
            accuracy: Self.drawerPositionCheckAccuracy
        )

        // Check drawer content by finding last item
        
        await runAction(drawer.swipeUpFast(), iterations: 2)
        
        let lastDrawerContentItem = app
            .staticTexts
            .matching(identifier: Self.lastDrawerContentItemIdentifier)
            .firstMatch
        
        XCTAssertTrue(lastDrawerContentItem.isHittable)
        
        // Check drawer mid position
        
        await runAction(
            drawer.swipeDownFast(),
            iterations: 3,
            sleepAfterAction: Self.drawerSwipeDuration
        )
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height
                - CGFloat(safeAreaInsets.bottom)
                - TabBarHeightProvider.sharedInstance.height
                - DrawerConstants.drawerDefaultMediumHeightConstant
                - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )

        // Check drawer bottom position
        
        await runAction(drawer.swipeDownFast())
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height - CGFloat(safeAreaInsets.bottom) - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )
    }
    
    @MainActor
    private func runAction(
        _ action: @escaping @autoclosure () -> Void,
        iterations: Int = 1,
        sleepAfterAction nanoseconds: UInt64 = SwiftUIDrawer_DemoUITests.drawerSwipeDuration
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
