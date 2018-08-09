//
//  TaskRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

public protocol TaskRepresentable {
    var request: RequestRepresentable { get }
    var response: ResponseRepresentable? { get }
    
    func resume() throws
    func cancel() throws
}
