//
//  ResponseRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

public protocol ResponseDataRepresentable {
    var raw: Data? { get }
}

public protocol ResponseRepresentable {
    var code: Int64 { get }
    var status: String { get }
    var data: ResponseDataRepresentable { get }
}
