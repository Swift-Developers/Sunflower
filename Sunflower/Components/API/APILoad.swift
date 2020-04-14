import Foundation
import Moya

public typealias Cancellable = Moya.Cancellable

private var singles: [AnyHashable: Cancellable] = [:]

public extension MoyaProvider {
    
    private typealias Null = API.Null
    private struct Response: Decodable {
        let code: Int
        let message: String
    }   
    
    /// 加载 (无结果)
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - options: 选项
    ///   - completion: 完成回调
    /// - Returns: Cancellable
    @discardableResult
    func load(_ target: Target,
              options: [API.Option] = .defalut,
              completion: (() -> Void)? = .none) -> Cancellable
    {
        return load(target, options: options) { (result: Bool) in
            completion?()
        }
    }
    
    /// 加载 (是否请求成功)
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - options: 选项
    ///   - completion: 完成回调
    /// - Returns: Cancellable
    @discardableResult
    func load(_ target: Target,
              options: [API.Option] = .defalut,
              completion: @escaping ((Bool) -> Void)) -> Cancellable
    {
        return load(target, options: options) { (result: API.Result<Null>) in
            completion(result.isSuccess)
        }
    }
    
    /// 加载 (泛型结果)
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - options: 选项
    ///   - completion: 完成回调
    /// - Returns: Cancellable
    @discardableResult
    func load<T: Decodable>(_ target: Target,
                            options: [API.Option] = .defalut,
                            completion: @escaping ((API.Result<T>) -> Void)) -> Cancellable
    {
        // 解析选项
        var progress: API.Progress?
        var prompt: API.Prompt?
        var retry: API.Option.Retry?
        var single: AnyHashable?
        var cancel: [Notification.Name] = []
        
        options.forEach {
            switch $0 {
            case .progress(let value):
                progress = value
            case .prompt(let value):
                prompt = value
            case .retry(let value):
                retry = value
            case .single(let value):
                single = value
            case .cancel(let value):
                cancel = value
            }
        }
        
        let cancellable = API.CancellableWrapper(target)
        
        // 进度回调
        let progressing: ProgressBlock = {
            progress?($0.progress)
        }
        
        // 单一标识
        if let single = single {
            singles[single]?.cancel()
            singles[single] = cancellable
        }
        // 取消监听
        let observers: [Any] = cancel.map {
            return NotificationCenter.default.addObserver(
                forName: $0,
                object: nil,
                queue: .main,
                using: { sender in
                    cancellable.cancel()
                }
            )
        }
        
        // 处理结果
        func processing(result: Moya.Response) {
            // 移除单一记录
            if let single = single {
                singles[single] = nil
            }
            // 移除取消监听
            observers.forEach{ NotificationCenter.default.removeObserver($0) }
            // 解析结果
            DispatchQueue.global().async {
                do {
                    let response = try result.map(Response.self)
                    if response.code >= 0 {
                        let data = try result.map(
                            T.self,
                            atKeyPath: "data",
                            failsOnEmptyData: false
                        )
                        DispatchQueue.main.async {
                            guard !cancellable.isCancelled else { return }
                            completion(.success(data))
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            guard !cancellable.isCancelled else { return }
                            prompt?(.service(.make(response.code)), response.message)
                            completion(.failure(.service(.make(response.code))))
                        }
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        guard !cancellable.isCancelled else { return }
                        prompt?(.mapping(.object(error)), "数据解析失败")
                        completion(.failure(.mapping(.object(error))))
                    }
                }
            }
        }
        // 请求失败
        func failured(_ error: API.Error) {
            // 移除单一记录
            if let single = single, !error.isRequestCancelled {
                singles[single] = nil
            }
            // 移除取消监听
            observers.forEach{ NotificationCenter.default.removeObserver($0) }
            // 失败回调
            prompt?(error, "网络请求失败")
            completion(.failure(error))
        }
        
        // 重新加载
        func reload(_ retry: API.Option.Retry, count: Int) {
            guard !cancellable.isCancelled else { return }
            
            cancellable.value = load(target, with: progressing) { (result) in
                switch result {
                case .success(let value):
                    processing(result: value)
                    
                case .failure(let error):
                    if count > 0, !error.isRequestCancelled {
                        let delay = retry.interval * pow(Double(retry.count - count), retry.decay)
                        DispatchQueue.main.asyncAfter(deadline: .now() + min(delay, 30)) {
                            reload(retry, count: count - 1)
                        }
                        
                    } else {
                        failured(error)
                    }
                }
            }
        }
        
        // 开始加载
        cancellable.value = load(target, with: progressing) { (result) in
            switch result {
            case .success(let value):
                processing(result: value)
                
            case .failure(let error):
                if let retry = retry, retry.count > 0, !error.isRequestCancelled {
                    reload(retry, count: retry.count - 1)
                    
                } else {
                    failured(error)
                }
            }
        }
        
        return cancellable
    }
    
    /// 加载 (原始响应)
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - options: 选项
    ///   - completion: 完成回调
    /// - Returns: Cancellable
    @discardableResult
    func load(_ target: Target,
              with progress: ProgressBlock? = .none,
              completion: @escaping ((API.Result<Moya.Response>) -> Void)) -> Cancellable
    {
        return request(target, callbackQueue: .main, progress: progress) {
            (result) in
            switch result {
            case .success(let value):
                completion(.success(value))
                
            case .failure(let error):
                completion(.failure(.request(.make(error))))
            }
        }
    }
}
