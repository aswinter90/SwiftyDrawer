import XCTest
import SwiftUIDrawer

/// The UI tests defined here serve as a playground for the author to catch up with the capabilities of XCUITests. In the long term they should probably be replaced with Snapshot tests (using the Point-Free framework, or similar)
final class SwiftUIDrawer_DemoUITests: XCTestCase {

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

        // Unfortunately there is no UIWindow available to grab the insets from in XCTestCases, that is why the insets are injected as an accessibility label from the UI hierarchy
        let safeAreaInsets = try SafeAreaInsetsHolder(data: drawer.label.data(using: .utf8) ?? .init())
        
        // Check top position
        
        drawer.swipeUp()
        try? await Task.sleep(nanoseconds: 800_000_000)

        XCTAssertEqual(drawer.frame.origin.y, safeAreaInsets.top)

        // Todo: Check mid position
        
        drawer.swipeDown()
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height
                - CGFloat(safeAreaInsets.bottom)
                - TabBarHeightProvider.sharedInstance.height
                - DrawerConstants.drawerDefaultMediumHeightConstant
                - DrawerConstants.dragHandleHeight
        )

        // Check bottom position
        
        drawer.swipeDown()
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        XCTAssertEqual(
            drawer.frame.origin.y,
            app.frame.height - CGFloat(safeAreaInsets.bottom) - DrawerConstants.dragHandleHeight
        )
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
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
