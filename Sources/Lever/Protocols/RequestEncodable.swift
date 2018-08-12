//
//  RequestEncodable.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

public protocol RequestEncodable {
    func encode(request: RequestConvertiable, with params: [AnyHashable: Any]) throws -> RequestConvertiable
}
