import Foundation
import Moya

extension API {
    
    public typealias Progress = (Double) -> Void
    public typealias Prompt = (API.Error, String) -> Void
    
    /// 选项
    ///
    /// - progress: 进度回调
    /// - prompt: 提示回调
    /// - retry: 重试配置
    /// - single: 单一标识 相同标识的请求只同时存在一个 会取消掉上一次的请求
    /// - cancel: 取消通知事件 收到指定通知 立即取消当前请求
    public enum Option {
        case progress(Progress)
        case prompt(Prompt)
        case retry(Retry)
        case single(AnyHashable?)
        case cancel([Notification.Name])
    }
}

extension API.Option {
    
    /// 重试配置
    public struct Retry {
        let count: Int
        let interval: Double
        let decay: Double
    }
}

extension API.Option.Retry {
    
    public static func count(_ value: Int) -> API.Option.Retry {
        return .init(count: value, interval: 1, decay: 1.2)
    }
    
    public static func force() -> API.Option.Retry {
        return .init(count: .max, interval: 1, decay: 1.2)
    }
}

public extension Array where Element == API.Option {
    
    static var defalut: [API.Option] = [
        .progress({ (progress) in
            
        }),
        .prompt { (error, msg) in
            guard !error.isRequestCancelled, !error.isServiceUnauthorized else { return }
            
//            Toast.show(top: msg, at: .failure)
        }
    ]
}
