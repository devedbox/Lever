import XCTest
@testable import Lever

final class LeverTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // XCTAssertEqual(Lever().text, "Hello, World!")
        let data: [String: String] = ["sasa": "1", "1": "sasa"]
        let json = try? JSONEncoder().encode(data)
        print(String(data: json!, encoding: .utf8)!)
    }

    func testRequest() {
        let exp = expectation(description: "resp")
        exp.expectedFulfillmentCount = 2
        let task = try? Lever.Session.shared.task(for: "https://api.github.com/repos/apple/swift/releases")
        task?.response { response, completion in
            print(response)
            completion(.allow)
            exp.fulfill()
        }
        task?.receiveData { data in
            print(String(data: data, encoding: .utf8) ?? "")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 120.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
