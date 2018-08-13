//
//  Lever.Error.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

/// A type alias represents the error of `Lever.Error` with `Void` context.
public typealias VoidError    = Lever.Error<Void>
/// A type alias represents the error of `Lever.Error` with `Session` context.
public typealias SessionError = Lever.Error<Session>

/// A type represents error of `Lever` module.
public struct Error<Context>: Swift.Error, CustomStringConvertible {
    /// The description of `LeverError`.
    public let description: String
    /// User info.
    public let context: Context?
    /// Creates instance of `Lever.Error` with the given string description contens and
    /// extra context info.
    ///
    /// - Parameters:
    ///    - description: Description value of the error.
    ///    - context: The associated error context.
    ///
    /// - Returns: An error instance of `Lever.Error` with the given info.
    public init(
        description: String,
        context: Context? = nil)
    {
        self.description = description
        self.context = context
    }
}
