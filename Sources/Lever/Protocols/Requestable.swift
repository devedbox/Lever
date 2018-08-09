//
//  Requestable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

public protocol Requestable {
    func request(_ request: RequestRepresentable) throws -> TaskRepresentable
}
