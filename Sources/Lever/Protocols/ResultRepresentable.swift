//
//  ResultRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/13.
//

import Foundation

public protocol ResultPresentable {
    func response(_ handler: (ResponseRepresentable) -> Void)
    func failure(_ handler: (Swift.Error) -> Void)
}
