//
//  Task.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

public class Task: NSObject, TaskRepresentable {
    public var request: RequestRepresentable {
        return _task.currentRequest!
    }
    
    public var response: ResponseRepresentable?
    
    
    private let _task: URLSessionTask
    
    public init(task: URLSessionTask) {
        _task = task
    }
}

extension Task {
    public func resume() throws {
        _task.resume()
    }
    
    public func cancel() throws {
        _task.cancel()
    }
}
