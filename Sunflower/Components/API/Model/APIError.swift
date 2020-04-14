import Foundation
import Moya

extension API {
    
    public enum Error: Swift.Error {
        /// 请求类型失败 (请求失败)
        case request(Request)
        /// 映射类型失败 (请求成功 解析映射时)
        case mapping(Mapping)
        /// 服务类型失败 (请求成功 接口服务code非0时)
        case service(Service)
    }
}

public extension API.Error {
    
    /// 是否请求取消
    var isRequestCancelled: Bool {
        switch self {
        case .request(let value):   return value.isCancelled
        default:                    return false
        }
    }
    
    /// 是否请求无网络
    var isRequestNotConnected: Bool {
        switch self {
        case .request(let value):   return value.isNotConnected
        default:                    return false
        }
    }
    
    /// 是否服务鉴权失败
    var isServiceUnauthorized: Bool {
        switch self {
        case .service(let value):   return value.isUnauthorized
        default:                    return false
        }
    }
    
    /// 错误码
    var code: Int? {
        switch self {
        case .request(let value):   return value.code
        case .service(let value):   return value.code
        default:                    return nil
        }
    }
}

extension API.Error {
    
    public enum Request {
        /// 请求超时
        case timeout
        /// 请求取消
        case cancelled
        /// 无网络连接
        case notConnected
        /// 其他错误
        case other(Swift.Error)
    }
    
    public enum Mapping {
        /// 对象映射失败
        case object(Swift.Error)
    }
    
    public enum Service {
        /// 鉴权失败
        case unauthorized
        /// 其他错误
        case other(Int)
    }
}

public extension API.Error.Request {
    
    /// 是否取消
    var isCancelled: Bool {
        if case .cancelled = self {
            return true
        }
        return false
    }
    
    /// 是否无网络连接
    var isNotConnected: Bool {
        if case .notConnected = self {
            return true
        }
        return false
    }
    
    var code: Int {
        switch self {
        case .timeout:          return NSURLErrorTimedOut
        case .cancelled:        return NSURLErrorCancelled
        case .notConnected:     return NSURLErrorNotConnectedToInternet
        case .other(let value): return (value as NSError).code
        }
    }
    
    static func make(_ error: MoyaError) -> API.Error.Request {
        if case .underlying(let error, _) = error {
            if (error as NSError).code == NSURLErrorTimedOut {
                return .timeout
            }
            if (error as NSError).code == NSURLErrorCancelled {
                return .cancelled
            }
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                return .notConnected
            }
            return .other(error)
        }
        return .other(error)
    }
}

public extension API.Error.Service {
    
    /// 错误码
    var code: Int {
        switch self {
        case .unauthorized:         return -3
        case .other(let value):     return value
        }
    }
    
    /// 是否为鉴权失败
    var isUnauthorized: Bool {
        switch self {
        case .unauthorized:         return true
        default:                    return false
        }
    }
    
    static func make(_ code: Int) -> API.Error.Service {
        switch code {
        // -3 Token校验失败
        case -3:                    return .unauthorized
        default:                    return .other(code)
        }
    }
}

extension API.Error: CustomStringConvertible {
    
    public var description: String {
        var output = "Error."
        switch self {
        case .request(let value):
            output += "request("
            print(value.description, terminator: "", to: &output)
            
        case .mapping(let value):
            output += "mapping("
            print(value.description, terminator: "", to: &output)
            
        case .service(let value):
            output += "service("
            print(value.description, terminator: "", to: &output)
        }
        output += ")"
        return output
    }
}

extension API.Error.Request: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .timeout:              return "请求超时"
        case .cancelled:            return "请求取消"
        case .notConnected:         return "无网络连接"
        case .other(let value):     return "\(value.localizedDescription)"
        }
    }
}

extension API.Error.Mapping: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .object(let value):     return "\(value.localizedDescription)"
        }
    }
}

extension API.Error.Service: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unauthorized:         return "鉴权失败"
        case .other(let value):     return "错误码: \(value)"
        }
    }
}
