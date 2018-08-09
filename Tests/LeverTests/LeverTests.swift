import XCTest
@testable import Lever

final class LeverTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Lever().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
