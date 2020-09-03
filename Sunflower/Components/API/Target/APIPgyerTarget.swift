import Moya
import Alamofire

extension API {
    static let pgyer = MoyaProvider<APIPgyerTarget>(plugins: plugins + [APIPgyerPlugin()])
}

enum APIPgyerTarget {
    /// 上传
    case upload(Pgyer.Upload)
    /// 列表
    case list(key: String)
}

extension APIPgyerTarget: TargetType {
    
    var baseURL: URL { URL(string: "https://www.pgyer.com/apiv2")! }
    
    var path: String {
        switch self {
        case .upload:               return "app/upload"
        case .list:                 return "app/listMy"
        }
    }
    
    var method: Moya.Method { .post }
    
    var task: Task {
        switch self {
        case let .upload(body):
            return .uploadMultipart([
                .init(provider: .file(body.file), name: "file"),
                .init(provider: .data(body.key.data(using: .utf8) ?? .init()), name: "_api_key"),
                .init(provider: .data(String(body.installType).data(using: .utf8) ?? .init()), name: "buildInstallType"),
                .init(provider: .data(body.password.data(using: .utf8) ?? .init()), name: "buildPassword"),
                .init(provider: .data(body.description.data(using: .utf8) ?? .init()), name: "buildUpdateDescription")
            ])
            
        case let .list(key):
            return .body(["_api_key": key])
        }
    }
    
    var sampleData: Data {
        .init()
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}

extension Task {
    
    fileprivate static func body(_ parameters: [String: Any]) -> Task {
        return .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.default
        )
    }
}
