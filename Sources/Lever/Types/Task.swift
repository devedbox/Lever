//
//  Task.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

// MARK: - Error.

extension Lever.Error {
    public static let taskIsInRunning = Lever.Error(description: "The state of given task is in running.")
    public static let taskIsCompleted = Lever.Error(description: "The state of given task is completed.")
    public static let taskIsCanceling = Lever.Error(description: "The state of given task is canceling.")
    public static let taskIsSuspended = Lever.Error(description: "The state of given task is suspended.")
}

// MARK: - Task.

public class Task: NSObject, TaskRepresentable {
    private var _willBeginDelayedRequestHandler: Any?
    @available(OSX 10.13, *)
    public var willBeginDelayedRequestHandler: ((URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)? {
        return _willBeginDelayedRequestHandler as? ((URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)
    }
    public private(set) var waitingForConnectivityHandler: (() -> Void)?
    public private(set) var redirectionHandler: ((HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void)?
    public private(set) var challengeHandler: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    public private(set) var needNewBodyStreamHandler: (((InputStream?) -> Void) -> Void)?
    public private(set) var sendDataHandler: ((Int64, Int64, Int64) -> Void)?
    private var _didFinishCollectingMetricsHandler: Any?
    @available(OSX 10.12, *)
    public var didFinishCollectingMetricsHandler: ((URLSessionTaskMetrics) -> Void)? {
        return _didFinishCollectingMetricsHandler as? ((URLSessionTaskMetrics) -> Void)
    }
    public private(set) var completeHandler: ((Swift.Error?) -> Void)?
    @available(OSX 10.13, *)
    public func willBeginDelayedRequest(_ handler: @escaping (URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void) {
        _willBeginDelayedRequestHandler = handler
        resumeIfPossible()
    }
    
    public func waitingForConnectivity(_ handler: @escaping () -> Void) {
        waitingForConnectivityHandler = handler
        resumeIfPossible()
    }
    
    public func challenge(_ handler: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) {
        challengeHandler = handler
        resumeIfPossible()
    }
    
    public func redirection(_ handler: @escaping (HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void) {
        redirectionHandler = handler
        resumeIfPossible()
    }
    
    public func needNewBodyStream(_ handler: @escaping ((InputStream?) -> Void) -> Void) {
        needNewBodyStreamHandler = handler
        resumeIfPossible()
    }
    
    public func send(_ handler: @escaping (Int64, Int64, Int64) -> Void) {
        sendDataHandler = handler
        resumeIfPossible()
    }
    
    @available(OSX 10.12, *)
    public func didFinishCollectingMetrics(_ handler: @escaping (URLSessionTaskMetrics) -> Void) {
        _didFinishCollectingMetricsHandler = handler
        resumeIfPossible()
    }
    
    public func complete(_ handler: @escaping (Swift.Error?) -> Void) {
        completeHandler = handler
        resumeIfPossible()
    }
    
    public var request: RequestRepresentable {
        return _task.currentRequest!
    }
    
    public var response: ResponseRepresentable?
    
    
    private let _task: URLSessionTask
    public var task: URLSessionTask { return _task }
    private let _session: Session
    
    public init(session: Session, task: URLSessionTask) {
        _session = session
        _task = task
    }
}

extension Task {
    public func resume() throws {
        switch _task.state {
        case .canceling:
            throw Lever.Error.taskIsCanceling
        case .completed:
            throw Lever.Error.taskIsCompleted
        case .running:
            throw Lever.Error.taskIsInRunning
        case .suspended:
            _task.resume()
        }
    }
    
    public func cancel() throws {
        switch _task.state {
        case .canceling:
            throw Lever.Error.taskIsCanceling
        case .completed:
            throw Lever.Error.taskIsCompleted
        case .running: fallthrough
        case .suspended:
            _task.cancel()
        }
    }
    
    public func suspend() throws {
        switch _task.state {
        case .canceling:
            throw Lever.Error.taskIsCanceling
        case .completed:
            throw Lever.Error.taskIsCompleted
        case .running:
            _task.suspend()
        case .suspended:
            throw Lever.Error.taskIsSuspended
        }
    }
}

public class DataTask: Task, DataTaskRepresentable {
    public private(set) var responseHandler: ((URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)?
    public private(set) var toDownloadHandler: ((URLSessionDownloadTask) -> Void)?
    private var _toStreamHandler: Any?
    @available(OSX 10.11, *)
    public var toStreamHandler: ((URLSessionStreamTask) -> Void)? {
        return _toStreamHandler as? ((URLSessionStreamTask) -> Void)
    }
    public private(set) var receiveDataHandler: ((Data) -> Void)?
    public private(set) var cacheResponseHandler: ((CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)?
    
    public func response(_ handler: @escaping (URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void) {
        responseHandler = handler
        resumeIfPossible()
    }
    
    public func toDownload(_ handler: @escaping (URLSessionDownloadTask) -> Void) {
        toDownloadHandler = handler
        resumeIfPossible()
    }
    
    @available(OSX 10.11, *)
    public func toStream(_ handler: @escaping (URLSessionStreamTask) -> Void) {
        _toStreamHandler = handler
        resumeIfPossible()
    }
    
    public func receiveData(_ handler: @escaping (Data) -> Void) {
        receiveDataHandler = handler
        resumeIfPossible()
    }
    
    public func cacheResponse(_ handler: @escaping (CachedURLResponse, (CachedURLResponse?) -> Void) -> Void) {
        cacheResponseHandler = handler
        resumeIfPossible()
    }
}

public class DownloadTask: Task, DownloadTaskRepresentable {
    public private(set) var downloadFinishHandler: ((URL) -> Void)?
    public private(set) var writingHandler: ((Int64, Int64, Int64) -> Void)?
    public private(set) var downloadResumingHandler: ((Int64, Int64) -> Void)?
    
    public func finish(_ handler: @escaping (URL) -> Void) {
        downloadFinishHandler = handler
        resumeIfPossible()
    }
    
    public func write(_ handler: @escaping (Int64, Int64, Int64) -> Void) {
        writingHandler = handler
        resumeIfPossible()
    }
    
    public func resume(_ handler: @escaping (Int64, Int64) -> Void) {
        downloadResumingHandler = handler
        resumeIfPossible()
    }
}

public class UploadTask: DataTask, UploadTaskRepresentable { }

public class StreamTask: Task, StreamTaskRepresentable {
    public private(set) var closedReadingHandler: (() -> Void)?
    public private(set) var closedWritingHandler: (() -> Void)?
    public private(set) var discoverBetterRouteHandler: (() -> Void)?
    public private(set) var toInOutStreamHandler: ((InputStream, OutputStream) -> Void)?
    
    public func closedReading(_ handler: @escaping () -> Void) {
        closedReadingHandler = handler
        resumeIfPossible()
    }
    
    public func closedWriting(_ handler: @escaping () -> Void) {
        closedWritingHandler = handler
        resumeIfPossible()
    }
    
    public func discoverBetterRoute(_ handler: @escaping () -> Void) {
        discoverBetterRouteHandler = handler
        resumeIfPossible()
    }
    
    public func toInOutStream(_ handler: @escaping (InputStream, OutputStream) -> Void) {
        toInOutStreamHandler = handler
        resumeIfPossible()
    }
}
