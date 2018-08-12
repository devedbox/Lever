//
//  Array.RemoveObject.swift
//  Lever
//
//  Created by devedbox on 2018/8/12.
//

import Foundation

extension Array where Element: AnyObject {
    public mutating func remove(object: Element) -> Element? {
        guard let index = firstIndex(where: { $0 === object }) else {
            return nil
        }
        return remove(at: index)
    }
}

extension Array where Element: Equatable {
    public mutating func remove(object: Element) -> Element? {
        guard let index = firstIndex(where: { $0 == object }) else {
            return nil
        }
        return remove(at: index)
    }
}
