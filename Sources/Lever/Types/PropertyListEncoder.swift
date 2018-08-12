//
//  PropertyListEncoder.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

public struct PropertyListEncoder: HTTPBodyEncoder {
    public func encode(contents: [AnyHashable : Any]) throws -> Data {
        return try PropertyListSerialization.data(fromPropertyList: contents, format: .xml, options: 0)
    }
}
