//
//  Session.swift
//  Lever
//
//  Created by devedbox on 2018/8/10.
//

import Foundation

// MARK: - Session.

public class Session: NSObject, SessionRepresentable {
    private struct _SharedToken {
        static let instance = Session(config: .default)
    }
    
    public class var shared: Session { return _SharedToken.instance }
    
    private let _session: URLSession
    public var session  : URLSession { return _session }
    
    private var _tasks         : [TaskRepresentable] {
        return _dataTasks     as [TaskRepresentable]
             + _downloadTasks as [TaskRepresentable]
             + _uploadTasks   as [TaskRepresentable]
             + _streamTasks   as [TaskRepresentable]
    }
    private var _dataTasks    : [DataTaskRepresentable]     = []
    private var _downloadTasks: [DownloadTaskRepresentable] = []
    private var _uploadTasks  : [UploadTaskRepresentable]   = []
    private var _streamTasks  : [StreamTaskRepresentable]   = []
    
    private let _sessionQueue = DispatchQueue(label: "com.session.lever")
    internal weak var sessionDelegate: SessionDelegate?
    
    public private(set) var invalidHandler  : ((Swift.Error?) -> Void)?
    public private(set) var challengeHandler: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    public init(session: URLSession) {
        _session = session
    }
}

extension Session {
    public convenience init(
        config: URLSessionConfiguration,
        delegate: URLSessionDelegate? = nil,
        delegateQueue: OperationQueue? = nil)
    {
        let sessionDelegate = SessionDelegate()
        self.init(session: .init(configuration: config, delegate: delegate ?? sessionDelegate, delegateQueue: delegateQueue))
        
        if case .none = delegate {
            sessionDelegate.sessionExtractor = { [unowned self] in self }
            sessionDelegate.taskExtractor = { [unowned self] task in self._task(for: task) }
            sessionDelegate.dataTaskExtractor = { [unowned self] task in self._dataTask(for: task) }
            sessionDelegate.downloadTaskExtrator = { [unowned self] task in self._downloadTask(for: task) }
            if #available(OSX 10.11, *) {
                sessionDelegate.streamTaskExtrator = { [unowned self] task in self._streamTask(for: task) }
            }
            sessionDelegate.taskDisposer = { [unowned self] task in self._removeTask(for: task) }
            self.sessionDelegate = sessionDelegate
        }
    }
}

// MARK: - Requestable.

//extension Session: Requestable {
//    public func request(_ request: RequestRepresentable) throws -> TaskRepresentable {
//        
//    }
//}

extension Session {
    public func task(for request: RequestConvertiable) throws -> DataTaskRepresentable {
        let task = DataTask(session: self, task: _session.dataTask(with: try request.asRequest()))
        _sessionQueue.sync { [unowned self] in self._dataTasks.append(task) }
        return task
    }
}

extension Session {
    public func download(from request: RequestConvertiable) throws -> DownloadTaskRepresentable {
        let task = DownloadTask(session: self, task: _session.downloadTask(with: try request.asRequest()))
        _sessionQueue.sync { [unowned self] in self._downloadTasks.append(task) }
        return task
    }
    
    public func download(with resumeData: Data) throws -> DownloadTaskRepresentable {
        let task = DownloadTask(session: self, task: _session.downloadTask(withResumeData: resumeData))
        _sessionQueue.sync { [unowned self] in self._downloadTasks.append(task) }
        return task
    }
}

extension Session {
    public func upload(
        to request: RequestConvertiable,
        from data: Data) throws -> UploadTaskRepresentable
    {
        let task = UploadTask(session: self, task: _session.uploadTask(with: try request.asRequest(), from: data))
        _sessionQueue.sync { [unowned self] in self._uploadTasks.append(task) }
        return task
    }
    
    public func upload(
        to request: RequestConvertiable,
        from file: URLConvertiable) throws -> UploadTaskRepresentable
    {
        let task = UploadTask(session: self, task: _session.uploadTask(with: try request.asRequest(), fromFile: try file.asURL()))
        _sessionQueue.sync { [unowned self] in self._uploadTasks.append(task) }
        return task
    }
}

// MARK: - Public.

extension Session {
    public var allTasks: [TaskRepresentable] { return _tasks }
    /// Returns all tasks for the given speficied task type `T` conforms to `TaskRepresentable`.
    ///
    /// - Parameter type: The type of the results tasks.
    /// - Returns: A list of tasks of type `T`.
    ///
    /// - Throws: **Lever.Error<T.Type>** if there is no matching results.
    public func tasks<T>(of type: T.Type) throws -> [T] where T: TaskRepresentable {
        switch type {
        case is DataTaskRepresentable.Type:     return _dataTasks     as! [T]
        case is DownloadTaskRepresentable.Type: return _downloadTasks as! [T]
        case is UploadTaskRepresentable.Type:   return _uploadTasks   as! [T]
        case is StreamTaskRepresentable.Type:   return _streamTasks   as! [T]
        default: throw Lever.Error<T.Type>(description: "Invalid task type for fetching tasks.", context: type)
        }
    }
    
    public func invalid(_ handler: @escaping (Swift.Error?) -> Void) {
        invalidHandler = handler
    }
    
    public func challenge(_ handler: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) {
        challengeHandler = handler
    }
}

// MARK: - Private.

extension Session {
    private func _task(for task: URLSessionTask) -> TaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in self._tasks.first { $0.task == task } }
    }
    
    private func _dataTask(for task: URLSessionDataTask) -> DataTaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in self._dataTasks.first { $0.task == task } }
    }
    
    private func _downloadTask(for task: URLSessionDownloadTask) -> DownloadTaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in self._downloadTasks.first { $0.task == task } }
    }
    
    private func _uploadTask(for task: URLSessionUploadTask) -> UploadTaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in self._uploadTasks.first { $0.task == task } }
    }
    
    @available(OSX 10.11, *)
    private func _streamTask(for task: URLSessionStreamTask) -> StreamTaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in self._streamTasks.first { $0.task == task } }
    }
    
    @discardableResult
    private func _removeTask(for task: URLSessionTask) -> TaskRepresentable? {
        return _sessionQueue.sync { [unowned self] in
            switch task {
            case let task as URLSessionUploadTask:
                return self._uploadTasks.firstIndex { $0.task == task }.flatMap { self._uploadTasks.remove(at: $0) }
            case let task as URLSessionDownloadTask:
                return self._downloadTasks.firstIndex { $0.task == task }.flatMap { self._downloadTasks.remove(at: $0) }
            case let task as URLSessionDataTask:
                return self._dataTasks.firstIndex { $0.task == task }.flatMap { self._dataTasks.remove(at: $0) }
            default:
                if #available(OSX 10.11, *) {
                    if let task = task as? URLSessionStreamTask {
                        return self._streamTasks.firstIndex { $0.task == task }.flatMap { self._streamTasks.remove(at: $0) }
                    }
                }
                return nil
            }
        }
    }
}
