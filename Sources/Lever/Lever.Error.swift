//
//  Lever.Error.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

/// A type represents error of `Lever` module.
public struct Error: Swift.Error, CustomStringConvertible {
    /// The description of `LeverError`.
    public let description: String
}
