//
//  RequestRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

public enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public protocol RequestRepresentable {
    var method: RequestMethod { get }
    var headers: [String: Any] { get }
    var parameters: [String: Any] { get }
    var url: URLConvertiable { get }
    
    init(url: URLConvertiable, headers: [String: Any], parameters: [String: Any], via method: RequestMethod) throws
}

extension RequestRepresentable {
    public static func request(for url: URLConvertiable, headers: [String: Any] = [:], parameters: [String: Any] = [:], method: RequestMethod = .get) throws -> Self {
        return try Self.init(url: url, headers: headers, parameters: parameters, via: method)
    }
}
