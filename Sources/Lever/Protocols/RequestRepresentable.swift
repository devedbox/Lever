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

// MARK: - RequestConvertiable.

public protocol RequestConvertiable {
    func asRequest() throws -> URLRequest
}

extension RequestConvertiable {
    public var request: URLRequest? { return try? asRequest() }
}

// MARK: - RequestRepresentable.

public protocol RequestRepresentable: RequestConvertiable {
    var method: RequestMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    // var url: URLConvertiable? { get }
    
    init(url: URLConvertiable, headers: [String: String], parameters: [String: Any], via method: RequestMethod) throws
}

extension RequestRepresentable {
    public static func request(for url: URLConvertiable, headers: [String: String] = [:], parameters: [String: Any] = [:], method: RequestMethod = .get) throws -> Self {
        return try Self.init(url: url, headers: headers, parameters: parameters, via: method)
    }
}

extension URL: RequestConvertiable {
    public func asRequest() throws -> URLRequest {
        return URLRequest(url: self)
    }
}

extension URLRequest: RequestRepresentable {
    public func asRequest() throws -> URLRequest {
        return self
    }
    
    public var method: RequestMethod {
        get {
            return RequestMethod(rawValue: httpMethod ?? "") ?? .get
        }
        
        set {
            httpMethod = newValue.rawValue
        }
    }
    
    public var headers: [String : String] {
        get {
            return allHTTPHeaderFields ?? [:]
        }
        
        set {
            newValue.forEach { self.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
    }
    
    public var parameters: [String : Any] {
        return [:] // return httpBody
    }
    
    public init(url: URLConvertiable, headers: [String : String], parameters: [String : Any], via method: RequestMethod) throws {
        self.init(url: try url.asURL(), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120.0)
        self.allHTTPHeaderFields = headers
    }
}
