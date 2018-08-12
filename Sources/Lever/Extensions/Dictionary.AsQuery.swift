//
//  Dictionary.AsQuery.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

extension Dictionary {
    public func asQuery() -> String {
        func _query<T>(_ dictionary: [AnyHashable: T]) -> [String] {
            return dictionary.flatMap({ (key, value) -> [String] in
                switch value {
                case let dic as [AnyHashable: T]:
                    return _query(dic.reduce([:]) { (result, next) -> [String: Any] in result.merging(["\(key)[\(next.key)]": next.value], uniquingKeysWith: { $1 }) })
                case let arr as [T]:
                    return arr.flatMap { _query(["\(key)[]": $0]) }
                case let bool as Bool:
                    return ["\("\(key)".escaped)=\(bool ? 1: 0)"]
                case let bool as ObjCBool:
                    return ["\("\(key)".escaped)=\(bool.boolValue ? 1: 0)"]
                case let optional as Any?:
                    return ["\("\(key)".escaped)=\("\(optional ?? NSNull())".escaped)"]
                case is Int, is Int8, is Int16, is Int32, is Int64, is UInt, is UInt8, is UInt16, is UInt32, is UInt64, is Float, is Float80, is Double, is CGFloat: fallthrough
                case is String, is Character, is Substring: fallthrough
                default:
                    return ["\("\(key)".escaped)=\("\(value)".escaped)"]
                }
            })
        }
        return _query(self).joined(separator: "&")
    }
}
