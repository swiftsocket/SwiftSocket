import XCTest
@testable import SwiftSocket

final class SwiftSocketTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftSocket().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
