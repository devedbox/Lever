//
//  JSONEncoder.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

public struct JSONEncoder: HTTPBodyEncoder {
    public func encode(contents: [AnyHashable : Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted])
    }
}
