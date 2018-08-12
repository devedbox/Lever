//
//  SessionDelegate.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

internal class SessionDelegate: NSObject {
    
    // MARK: TasksExtractor.
    
    public var sessionExtractor: (() -> SessionRepresentable?)?
    public var taskExtractor: ((URLSessionTask) -> TaskRepresentable?)?
    public var dataTaskExtractor: ((URLSessionDataTask) -> DataTaskRepresentable?)?
    public var downloadTaskExtrator: ((URLSessionDownloadTask) -> DownloadTaskRepresentable?)?
    private var _streamTaskExtrator: Any?
    @available(OSX 10.11, *)
    public var streamTaskExtrator: ((URLSessionStreamTask) -> StreamTaskRepresentable?)? {
        get {
            return _streamTaskExtrator as? ((URLSessionStreamTask) -> StreamTaskRepresentable?)
        }
        set {
            _streamTaskExtrator = newValue
        }
    }
    public var taskDisposer: ((URLSessionTask) -> Void)?
    
    // MARK: Session.
    
    public var sessionDidBecomeInvalidWithError: ((URLSession, Swift.Error?) -> Void)?
    public var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    // MARK: Task.
    
    private var _taskWillBeginDelayedRequest: Any?
    @available(iOS 11.0, OSX 10.13, *)
    public var taskWillBeginDelayedRequest: ((URLSession, URLSessionTask, URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)? {
        get {
            return _taskWillBeginDelayedRequest as? ((URLSession, URLSessionTask, URLRequest, (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) -> Void)
        }
        set {
            _taskWillBeginDelayedRequest = newValue
        }
    }
    
    public var taskIsWaitingForConnectivity: (( URLSession, URLSessionTask) -> Void)?
    public var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void)?
    public var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    public var taskNeedNewBodyStream: ((URLSession, URLSessionTask, (InputStream?) -> Void) -> Void)?
    public var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
    
    private var _taskDidFinishCollecting: Any?
    @available(OSX 10.12, *)
    public var taskDidFinishCollectingMetrics: ((URLSession, URLSessionTask, URLSessionTaskMetrics) -> Void)? {
        get {
            return _taskDidFinishCollecting as? ((URLSession, URLSessionTask, URLSessionTaskMetrics) -> Void)
        }
        set {
            _taskDidFinishCollecting = newValue
        }
    }
    public var taskDidCompleteWithError: ((URLSession, URLSessionTask, Swift.Error?) -> Void)?
    
    // MARK: DataTask.
    
    public var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse, (URLSession.ResponseDisposition) -> Void) -> Void)?
    public var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
    private var _dataTaskDidBecomeStreamTask: Any?
    @available(OSX 10.11, *)
    public var dataTaskDidBecomeStreamTask: ((URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)? {
        get {
            return _dataTaskDidBecomeStreamTask as? ((URLSession, URLSessionDataTask, URLSessionStreamTask) -> Void)
        }
        set {
            _dataTaskDidBecomeStreamTask = newValue
        }
    }
    public var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    public var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse, (CachedURLResponse?) -> Void) -> Void)?
    
    // MARK: DownloadTask.
    
    public var downloadTaskDidFinishDownloading: ((URLSession, URLSessionDownloadTask, URL) -> Void)?
    public var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
    public var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
    
    // MARK: StreamTask.
    
    private var _streamTaskReadClosed: Any?
    @available(OSX 10.11, *)
    public var streamTaskReadClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskReadClosed as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskReadClosed = newValue
        }
    }
    private var _streamTaskWriteClosed: Any?
    @available(OSX 10.11, *)
    public var streamTaskWriteClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskWriteClosed as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskWriteClosed = newValue
        }
    }
    private var _streamTaskBetterRouteDiscoveredFor: Any?
    @available(OSX 10.11, *)
    public var streamTaskBetterRouteDiscovered: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskBetterRouteDiscoveredFor as? ((URLSession, URLSessionStreamTask) -> Void)
        }
        set {
            _streamTaskBetterRouteDiscoveredFor = newValue
        }
    }
    private var _streamTaskDidBecomeInputOutputStream: Any?
    @available(OSX 10.11, *)
    public var streamTaskDidBecomeInputOutputStream: ((URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void)? {
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
    func urlSession(
        _ session: URLSession,
        didBecomeInvalidWithError error: Swift.Error?)
    {
        sessionExtractor?()?.invalidHandler?(error)
            ?? sessionDidBecomeInvalidWithError?(session, error)
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        sessionExtractor?()?.challengeHandler?(challenge, completionHandler)
            ?? sessionDidReceiveChallenge?(session, challenge, completionHandler)
            ?? completionHandler(.performDefaultHandling, nil)
    }
}

// MARK: - URLSessionTaskDelegate.

extension SessionDelegate: URLSessionTaskDelegate {
    @available(iOS 11.0, OSX 10.13, *)
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willBeginDelayedRequest request: URLRequest,
        completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void)
    {
        taskExtractor?(task)?.willBeginDelayedRequestHandler?(request, completionHandler)
            ?? taskWillBeginDelayedRequest?(session, task, request, completionHandler)
            ?? completionHandler(.continueLoading, nil)
    }
    
    @available(OSX 10.13, *)
    func urlSession(
        _ session: URLSession,
        taskIsWaitingForConnectivity task: URLSessionTask)
    {
        taskExtractor?(task)?.waitingForConnectivityHandler?()
            ?? taskIsWaitingForConnectivity?(session, task)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        taskExtractor?(task)?.redirectionHandler?(response, request, completionHandler)
            ?? taskWillPerformHTTPRedirection?(session, task, response, request, completionHandler)
            ?? completionHandler(request)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        taskExtractor?(task)?.challengeHandler?(challenge, completionHandler)
            ?? taskDidReceiveChallenge?(session, task, challenge, completionHandler)
            ?? completionHandler(.performDefaultHandling, nil)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        taskExtractor?(task)?.needNewBodyStreamHandler?(completionHandler)
            ?? taskNeedNewBodyStream?(session, task, completionHandler)
            ?? completionHandler(nil)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        taskExtractor?(task)?.sendDataHandler?(bytesSent, totalBytesSent, totalBytesExpectedToSend)
            ?? taskDidSendBodyData?(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
    }
    
    @available(OSX 10.12, *)
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics)
    {
        taskExtractor?(task)?.didFinishCollectingMetricsHandler?(metrics)
            ?? taskDidFinishCollectingMetrics?(session, task, metrics)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Swift.Error?)
    {
        taskExtractor?(task)?.completeHandler?(error)
            ?? taskDidCompleteWithError?(session, task, error)
        taskDisposer?(task)
    }
}

// MARK: - URLSessionDataDelegate.

extension SessionDelegate: URLSessionDataDelegate {
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        dataTaskExtractor?(dataTask)?.responseHandler?(response, completionHandler)
            ?? dataTaskDidReceiveResponse?(session, dataTask, response, completionHandler)
            ?? completionHandler(.allow)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        dataTaskExtractor?(dataTask)?.toDownloadHandler?(downloadTask)
            ?? dataTaskDidBecomeDownloadTask?(session, dataTask, downloadTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask)
    {
        dataTaskExtractor?(dataTask)?.toStreamHandler?(streamTask)
            ?? dataTaskDidBecomeStreamTask?(session, dataTask, streamTask)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask, didReceive data: Data)
    {
        dataTaskExtractor?(dataTask)?.receiveDataHandler?(data)
            ?? dataTaskDidReceiveData?(session, dataTask, data)
    }
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        dataTaskExtractor?(dataTask)?.cacheResponseHandler?(proposedResponse, completionHandler)
            ?? dataTaskWillCacheResponse?(session, dataTask, proposedResponse, completionHandler)
            ?? completionHandler(proposedResponse)
    }
}

// MARK: - URLSessionDownloadDelegate.

extension SessionDelegate: URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        downloadTaskExtrator?(downloadTask)?.downloadFinishHandler?(location)
            ?? downloadTaskDidFinishDownloading?(session, downloadTask, location)
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        downloadTaskExtrator?(downloadTask)?.writingHandler?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
            ?? downloadTaskDidWriteData?(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        downloadTaskExtrator?(downloadTask)?.downloadResumingHandler?(fileOffset, expectedTotalBytes)
            ?? downloadTaskDidResumeAtOffset?(session, downloadTask, fileOffset, expectedTotalBytes)
    }
}

// MARK: - URLSessionStreamDelegate.

extension SessionDelegate: URLSessionStreamDelegate {
    @available(OSX 10.11, *)
    func urlSession(
        _ session: URLSession,
        readClosedFor streamTask: URLSessionStreamTask)
    {
        streamTaskExtrator?(streamTask)?.closedReadingHandler?()
            ?? streamTaskReadClosed?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(
        _ session: URLSession,
        writeClosedFor streamTask: URLSessionStreamTask)
    {
        streamTaskExtrator?(streamTask)?.closedWritingHandler?()
            ?? streamTaskWriteClosed?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(
        _ session: URLSession,
        betterRouteDiscoveredFor streamTask: URLSessionStreamTask)
    {
        streamTaskExtrator?(streamTask)?.discoverBetterRouteHandler?()
            ?? streamTaskBetterRouteDiscovered?(session, streamTask)
    }
    
    @available(OSX 10.11, *)
    func urlSession(
        _ session: URLSession,
        streamTask: URLSessionStreamTask,
        didBecome inputStream: InputStream,
        outputStream: OutputStream)
    {
        streamTaskExtrator?(streamTask)?.toInOutStreamHandler?(inputStream, outputStream)
            ?? streamTaskDidBecomeInputOutputStream?(session, streamTask, inputStream, outputStream)
    }
}
