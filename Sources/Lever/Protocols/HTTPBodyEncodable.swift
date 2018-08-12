//
//  HTTPBodyEncodable.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

public protocol HTTPBodyEncoder {
    func encode(contents: [AnyHashable: Any]) throws -> Data
}

public protocol HTTPBodyEncodable {
    func encode(with encoder: HTTPBodyEncoder) throws -> Data
}

extension HTTPBodyEncodable {
    public func encode(contents: [AnyHashable: Any], with encoder: HTTPBodyEncoder) throws -> Data {
        return try encoder.encode(contents: contents)
    }
}
