//
//  Session.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

public class Session: NSObject {
    
    private let _session: URLSession
    internal var sessionDelegate: SessionDelegate? {
        return _session.delegate as? SessionDelegate
    }
    
    public init(session: URLSession) {
        _session = session
    }
}

extension Session {
    public convenience init(config: URLSessionConfiguration,
                            delegate: URLSessionDelegate? = nil,
                            delegateQueue: OperationQueue? = nil)
    {
        self.init(session: .init(configuration: config, delegate: delegate ?? SessionDelegate(), delegateQueue: delegateQueue))
    }
}

// MARK: - Requestable.

//extension Session: Requestable {
//    public func request(_ request: RequestRepresentable) throws -> TaskRepresentable {
//        
//    }
//}

extension Session {
    public func task(for request: RequestConvertiable) throws -> TaskRepresentable {
        return _session.dataTask(with: try request.asRequest())
    }
}

extension Session {
    public func download(from request: RequestConvertiable) throws -> TaskRepresentable {
        return _session.downloadTask(with: try request.asRequest())
    }
    
    public func download(with resumeData: Data) throws -> TaskRepresentable {
        return _session.downloadTask(withResumeData: resumeData)
    }
}

extension Session {
    public func upload(to request: RequestConvertiable, from data: Data) throws -> TaskRepresentable {
        return _session.uploadTask(with: try request.asRequest(), from: data)
    }
    
    public func upload(to request: RequestConvertiable, from file: URLConvertiable) throws -> TaskRepresentable {
        return _session.uploadTask(with: try request.asRequest(), fromFile: try file.asURL())
    }
}

// MARK: - Public.

extension Session {
    @available(macOS 10.11, *)
    public func allTasks(_ results: @escaping ([Task]) -> Void) {
        _session.getAllTasks { tasks in
            results(tasks.map { .init(task: $0) })
        }
    }
}
