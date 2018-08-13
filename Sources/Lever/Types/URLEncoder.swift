//
//  URLEncoder.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

// MARK: - Error.

extension Lever.Error where Context == Void {
    public static let createsUrlComponentsFailed = VoidError(description: "Creates url components failed.")
    public static let nilUrlValueFromUrlComponents = VoidError(description: "Fetched nil value from 'URLComponents.url'.")
}

// MARK: - URLEncoder.

public struct URLEncoder {
    public func encode(url: URLConvertiable, with params: [AnyHashable: Any]) throws -> URLConvertiable {
        guard var urlComps = URLComponents(url: try url.asURL(), resolvingAgainstBaseURL: false) else {
            throw Lever.Error.createsUrlComponentsFailed
        }
        urlComps.percentEncodedQuery = (urlComps.percentEncodedQuery.map { $0 + "&" } ?? "") + params.asQuery()
        
        guard let url = urlComps.url else {
            throw Lever.Error.nilUrlValueFromUrlComponents
        }
        
        return url
    }
}
