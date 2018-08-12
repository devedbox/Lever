//
//  URLConvertiable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

// MARK: - Errors.

extension Lever.Error {
    public static let urlInitFailed = Lever.Error(description: "Creates instance of URL failed via 'init(string: String)'")
}

// MARK: - URLConvertiable.

public protocol URLConvertiable: RequestConvertiable {
    func asURL() throws -> URL
}

extension URLConvertiable {
    public func asRequest() throws -> URLRequest {
        return URLRequest(url: try asURL())
    }
}

// MARK: - Property.

extension URLConvertiable {
    public var url: URL? { return try? asURL() }
}

// MARK: - Extensions.

extension URL: URLConvertiable {
    public func asURL() throws -> URL { return self }
}

extension String: URLConvertiable {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw Lever.Error.urlInitFailed
        }
        return url
    }
}
