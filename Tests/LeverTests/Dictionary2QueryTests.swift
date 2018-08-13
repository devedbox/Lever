//
//  Dictionary2QueryTests.swift
//  LeverTests
//
//  Created by devedbox on 2018/8/11.
//

import XCTest
@testable import Lever

class Dictionary2QueryTests: XCTestCase {
    static var allTests = [
        ("testSimpleAsQuery", testSimpleAsQuery),
    ]
    
    func testSimpleAsQuery() {
        let dic = ["loc": 1, "subtype": 2, "type": "typeVal", "anotherType": ["这是个中文", "This is a message."]] as [String : Any]
        print(dic.asQuery())
    }
}
