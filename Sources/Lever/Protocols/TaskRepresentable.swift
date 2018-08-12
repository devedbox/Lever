//
//  TaskRepresentable.swift
//  Lever
//
//  Created by devedbox on 2018/8/9.
//

import Foundation

public protocol TaskResponsable {
    @available(OSX 10.13, *)
    var willBeginDelayedRequestHandler: ((URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)? { get }
    var waitingForConnectivityHandler: (() -> Void)? { get }
    var redirectionHandler: ((HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void)? { get }
    var challengeHandler: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)? { get }
    var needNewBodyStreamHandler: (((InputStream?) -> Void) -> Void)? { get }
    var sendDataHandler: ((Int64, Int64, Int64) -> Void)? { get }
    @available(OSX 10.12, *)
    var didFinishCollectingMetricsHandler: ((URLSessionTaskMetrics) -> Void)? { get }
    var completeHandler: ((Swift.Error?) -> Void)? { get }
    
    @available(OSX 10.13, *)
    func willBeginDelayedRequest(_ handler: @escaping (URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)
    func waitingForConnectivity(_ handler: @escaping () -> Void)
    func redirection(_ handler: @escaping (HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void)
    func challenge(_ handler: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)
    func needNewBodyStream(_ handler: @escaping ((InputStream?) -> Void) -> Void)
    func send(_ handler: @escaping (Int64, Int64, Int64) -> Void)
    @available(OSX 10.12, *)
    func didFinishCollectingMetrics(_ handler: @escaping (URLSessionTaskMetrics) -> Void)
    func complete(_ handler: @escaping (Swift.Error?) -> Void)
}

public protocol DataTaskResposable: TaskResponsable {
    var responseHandler: ((URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)? { get }
    var toDownloadHandler: ((URLSessionDownloadTask) -> Void)? { get }
    @available(OSX 10.11, *)
    var toStreamHandler: ((URLSessionStreamTask) -> Void)? { get }
    var receiveDataHandler: ((Data) -> Void)? { get }
    var cacheResponseHandler: ((CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)? { get  }
    
    func response(_ handler: @escaping (URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)
    func toDownload(_ handler: @escaping (URLSessionDownloadTask) -> Void)
    @available(OSX 10.11, *)
    func toStream(_ handler: @escaping (URLSessionStreamTask) -> Void)
    func receiveData(_ handler: @escaping (Data) -> Void)
    func cacheResponse(_ handler: @escaping (CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)
}

public protocol DownloadTaskResponsable: TaskResponsable {
    var downloadFinishHandler: ((URL) -> Void)? { get }
    var writingHandler: ((Int64, Int64, Int64) -> Void)? { get }
    var downloadResumingHandler: ((Int64, Int64) -> Void)? { get }
    
    func finish(_ handler: @escaping (URL) -> Void)
    func write(_ handler: @escaping (Int64, Int64, Int64) -> Void)
    func resume(_ handler: @escaping (Int64, Int64) -> Void)
}

public protocol UploadTaskResponsable: DataTaskResposable { }

public protocol StreamTaskResponsable: TaskResponsable {
    var closedReadingHandler: (() -> Void)? { get }
    var closedWritingHandler: (() -> Void)? { get }
    var discoverBetterRouteHandler: (() -> Void)? { get }
    var toInOutStreamHandler: ((InputStream, OutputStream) -> Void)? { get }
    
    func closedReading(_ handler: @escaping () -> Void)
    func closedWriting(_ handler: @escaping () -> Void)
    func discoverBetterRoute(_ handler: @escaping () -> Void)
    func toInOutStream(_ handler: @escaping (InputStream, OutputStream) -> Void)
}


public protocol TaskRepresentable: TaskResponsable {
    // var session: SessionRepresentable { get }
    var request: RequestRepresentable { get }
    var response: ResponseRepresentable? { get }
    var task: URLSessionTask { get }
    
    func resume() throws
    func cancel() throws
    func suspend() throws
    
    func resumeIfPossible()
    func cancelIfPossible()
    func suspendIfPossible()
}

extension TaskRepresentable {
    public func resumeIfPossible() {
        try? resume()
    }
    
    public func cancelIfPossible() {
        try? cancel()
    }
    
    public func suspendIfPossible() {
        try? suspend()
    }
}

public protocol DataTaskRepresentable: TaskRepresentable, DataTaskResposable { }

public protocol DownloadTaskRepresentable: TaskRepresentable, DownloadTaskResponsable { }

public protocol UploadTaskRepresentable: TaskRepresentable, UploadTaskResponsable { }

public protocol StreamTaskRepresentable: TaskRepresentable, StreamTaskResponsable { }
