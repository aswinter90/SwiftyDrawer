import XCTest
import SwiftUIDrawer

/// The UI tests defined here serve as a playground for the author to catch up with the capabilities of XCUITests. In the long term they should probably be replaced with Snapshot tests (using the Point-Free framework, or similar)
final class SwiftUIDrawer_DemoUITests: XCTestCase {

    private static let drawerSwipeDuration: UInt64 = 800_000_000
    private static let drawerPositionCheckAccuracy = 0.1
    
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
    func testDrawerPositions() async throws {
        let app = XCUIApplication()
        app.launch()
        
        let drawer = app.otherElements.matching(identifier: "SwiftUIDrawer").firstMatch
        XCTAssertTrue(drawer.exists)

        // Unfortunately there is no UIWindow available to grab the insets from in XCTestCases, hence the insets are injected as an accessibility label from the UI hierarchy. Which is rather a hack...
        let safeAreaInsets = try SafeAreaInsetsHolder(data: drawer.label.data(using: .utf8)!)
        
        // Check top position
        
        drawer.swipeUp()
        try await Task.sleep(nanoseconds: Self.drawerSwipeDuration)

        XCTAssertEqual(drawer.frame.origin.y, safeAreaInsets.top, accuracy: Self.drawerPositionCheckAccuracy)

        // Check mid position
        
        drawer.swipeDown()
        try await Task.sleep(nanoseconds: Self.drawerSwipeDuration)
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height
                - CGFloat(safeAreaInsets.bottom)
                - TabBarHeightProvider.sharedInstance.height
                - DrawerConstants.drawerDefaultMediumHeightConstant
                - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )

        // Check bottom position
        
        drawer.swipeDown()
        
        try await Task.sleep(nanoseconds: Self.drawerSwipeDuration)
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height - CGFloat(safeAreaInsets.bottom) - DrawerConstants.dragHandleHeight,
            accuracy: Self.drawerPositionCheckAccuracy
        )
    }
}

private struct SafeAreaInsetsHolder: Decodable {
    let top: CGFloat
    let bottom: CGFloat
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(SafeAreaInsetsHolder.self, from: data)
    }
    
    enum CodingKeys: String, CodingKey {
        case top = "safeAreaTop"
        case bottom = "safeAreaBottom"
    }
}
