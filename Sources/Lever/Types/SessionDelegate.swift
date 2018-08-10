//
//  SessionDelegate.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

internal class SessionDelegate: NSObject {
    
    // MARK: Session.
    
    public var sessionDidBecomeInvalidWithError: ((_ session: URLSession, _ error: Swift.Error?) -> Void)?
    public var sessionDidReceiveChallenge: ((_ session: URLSession, _ challenge: URLAuthenticationChallenge, _ completion: (_ disposition: URLSession.AuthChallengeDisposition, _ credential: URLCredential?) -> Void) -> Void)?
    
    // MARK: Task.
    
    private var _taskWillBeginDelayedRequest: Any?
    @available(OSX 10.13, *)
    public var taskWillBeginDelayedRequest: ((_ session: URLSession, _ task: URLSessionTask, _ request: URLRequest, _ completion: (_ disposition: URLSession.DelayedRequestDisposition, _ request: URLRequest?) -> Void) -> Void)? {
        get {
            return _taskWillBeginDelayedRequest as? ((URLSession, URLSessionTask, URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)
        }
        set {
            _taskWillBeginDelayedRequest = newValue
        }
    }
    
    public var taskIsWaitingForConnectivity: ((_ session: URLSession, _ task: URLSessionTask) -> Void)?
    public var taskWillPerformHTTPRedirection: ((_ session: URLSession, _ task: URLSessionTask, _ response: HTTPURLResponse, _ request: URLRequest, _ completion: (_ request: URLRequest?) -> Void) -> Void)?
    public var taskDidReceiveChallenge: ((_ session: URLSession, _ task: URLSessionTask, _ challenge: URLAuthenticationChallenge, _ completion: (_ disposition: URLSession.AuthChallengeDisposition, _ credential: URLCredential?) -> Void) -> Void)?
    public var taskNeedNewBodyStream: ((_ session: URLSession, _ task: URLSessionTask, _ completion: (_ stream: InputStream?) -> Void) -> Void)?
    public var taskDidSendBodyData: ((_ session: URLSession, _ task: URLSessionTask, _ bytesSent: Int64, _ totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64) -> Void)?
    
    private var _taskDidFinishCollecting: Any?
    @available(OSX 10.12, *)
    public var taskDidFinishCollectingMetrics: ((_ session: URLSession, _ task: URLSessionTask, _ metrics: URLSessionTaskMetrics) -> Void)? {
        get {
            return _taskDidFinishCollecting as? ((URLSession, URLSessionTask, URLSessionTaskMetrics) -> Void)
        }
        set {
            _taskDidFinishCollecting = newValue
        }
    }
    public var taskDidCompleteWithError: ((_ session: URLSession, _ task: URLSessionTask, _ error: Swift.Error?) -> Void)?
    
    // MARK: DataTask.
    
    public var dataTaskDidReceiveResponse: ((_ session: URLSession, _ task: URLSessionDataTask, _ response: URLResponse, _ completion: (_ disposition: URLSession.ResponseDisposition) -> Void) -> Void)?
    public var dataTaskDidBecomeDownloadTask: ((_ session: URLSession, _ task: URLSessionDataTask, _ downloadTask: URLSessionDownloadTask) -> Void)?
    private var _dataTaskDidBecomeStreamTask: Any?
    @available(OSX 10.11, *)
    public var dataTaskDidBecomeStreamTask: ((_ session: URLSession, _ task: URLSessionDataTask, _ streamTask: URLSessionStreamTask) -> Void)? {
        get {
            return _dataTaskDidBecomeStreamTask as? ((URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)
        }
        set {
            _dataTaskDidBecomeStreamTask = newValue
        }
    }
    public var dataTaskDidReceiveData: ((_ session: URLSession, _ task: URLSessionDataTask, _ data: Data) -> Void)?
    public var dataTaskWillCacheResponse: ((_ session: URLSession, _ task: URLSessionDataTask, _ response: CachedURLResponse, _ completion: (_ response: CachedURLResponse?) -> Void) -> Void)?
    
    // MARK: DownloadTask.
    
    public var downloadTaskDidFinishDownloading: ((_ session: URLSession, _ task: URLSessionDownloadTask, _ location: URL) -> Void)?
    public var downloadTaskDidWriteData: ((_ session: URLSession, _ task: URLSessionDownloadTask, _ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void)?
    public var downloadTaskDidResumeAtOffset: ((_ session: URLSession, _ task: URLSessionDownloadTask, _ fileOffset: Int64, _ expectedTotalBytes: Int64) -> Void)?
    
    // MARK: StreamTask.
    
    private var _streamTaskReadClosed: Any?
    @available(OSX 10.11, *)
    public var streamTaskReadClosed: ((_ session: URLSession, _ task: URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskReadClosed as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskReadClosed = newValue
        }
    }
    private var _streamTaskWriteClosed: Any?
    @available(OSX 10.11, *)
    public var streamTaskWriteClosed: ((_ session: URLSession, _ task: URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskWriteClosed as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskWriteClosed = newValue
        }
    }
    private var _streamTaskBetterRouteDiscoveredFor: Any?
    @available(OSX 10.11, *)
    public var streamTaskBetterRouteDiscovered: ((_ session: URLSession, _ task: URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskBetterRouteDiscoveredFor as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskBetterRouteDiscoveredFor = newValue
        }
    }
    private var _streamTaskDidBecomeInputOutputStream: Any?
    @available(OSX 10.11, *)
    public var streamTaskDidBecomeInputOutputStream: ((_ session: URLSession, _ task: URLSessionStreamTask, _ inputStream: InputStream, _ outputStream: OutputStream) -> Void)? {
        get {
            return _streamTaskDidBecomeInputOutputStream as? ((URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void)
        }
        set {
            _streamTaskDidBecomeInputOutputStream = newValue
        }
    }
}

// MARK: - URLSessionDelegate.

extension SessionDelegate: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Swift.Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionDidReceiveChallenge?(session, challenge, completionHandler)
    }
}

// MARK: - URLSessionTaskDelegate.

extension SessionDelegate: URLSessionTaskDelegate {
    @available(OSX 10.13, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        taskWillBeginDelayedRequest?(session, task, request, completionHandler)
    }
    
    @available(OSX 10.13, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        taskIsWaitingForConnectivity?(session, task)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        taskWillPerformHTTPRedirection?(session, task, response, request, completionHandler)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        taskDidReceiveChallenge?(session, task, challenge, completionHandler)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        taskNeedNewBodyStream?(session, task, completionHandler)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        taskDidSendBodyData?(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
    }
    
    @available(OSX 10.12, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        taskDidFinishCollectingMetrics?(session, task, metrics)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
        taskDidCompleteWithError?(session, task, error)
    }
}

// MARK: - URLSessionDataDelegate.

extension SessionDelegate: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dataTaskDidReceiveResponse?(session, dataTask, response, completionHandler)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        dataTaskDidBecomeDownloadTask?(session, dataTask, downloadTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        dataTaskDidBecomeStreamTask?(session, dataTask, streamTask)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataTaskDidReceiveData?(session, dataTask, data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        dataTaskWillCacheResponse?(session, dataTask, proposedResponse, completionHandler)
    }
}

// MARK: - URLSessionDownloadDelegate.

extension SessionDelegate: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadTaskDidFinishDownloading?(session, downloadTask, location)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadTaskDidWriteData?(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        downloadTaskDidResumeAtOffset?(session, downloadTask, fileOffset, expectedTotalBytes)
    }
}

// MARK: - URLSessionStreamDelegate.

extension SessionDelegate: URLSessionStreamDelegate {
    @available(OSX 10.11, *)
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        streamTaskReadClosed?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        streamTaskWriteClosed?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        streamTaskBetterRouteDiscovered?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        streamTaskDidBecomeInputOutputStream?(session, streamTask, inputStream, outputStream)
    }
}
