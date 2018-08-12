//
//  SessionRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/11.
//

import Foundation

public protocol SessionResponsable {
    var invalidHandler: ((_ error: Swift.Error?) -> Void)? { get }
    var challengeHandler: ((_ challenge: URLAuthenticationChallenge, _ completion:  (_ disposition: URLSession.AuthChallengeDisposition, _ credential: URLCredential?) -> Void) -> Void)? { get }
    
    func invalid(_ handler: @escaping (_ error: Swift.Error?) -> Void)
    func challenge(_ handler: @escaping (_ challenge: URLAuthenticationChallenge, _ completion:  (_ disposition: URLSession.AuthChallengeDisposition, _ credential: URLCredential?) -> Void) -> Void)
}

public protocol SessionRepresentable: SessionResponsable {
    var session: URLSession { get }
}
