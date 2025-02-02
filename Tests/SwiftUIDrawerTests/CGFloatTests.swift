import Testing
import Foundation
@testable import SwiftUIDrawer

@Suite("CGFloatTests")
struct CGFloatTests {
    @Test func testRoundToDecimal() async throws {
        let rounded1 = CGFloat(1.23456789).roundToDecimal(3)
        #expect(rounded1 == 1.235)
        
        let rounded2 = CGFloat(5.03693).roundToDecimal(4)
        #expect(rounded2 == 5.0369)
        
        let rounded3 = CGFloat(10.9).roundToDecimal(0)
        #expect(rounded3 == 11)
    }
}
