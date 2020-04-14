import Moya

extension API {
    
    static let feishu = MoyaProvider<APIFeishuTarget>(plugins: plugins)
}

enum APIFeishuTarget {
    /// 发送消息
    case sendText(key: String, title: String, content: String)
}

extension APIFeishuTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://open.feishu.cn/open-apis/bot/hook")!
    }
    
    var path: String {
        switch self {
        case let .sendText(key, _, _):
            return "\(key)"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .sendText(_, title, content):
            let body: [String: Any] = ["title": title, "text": content]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        return ["content-Type": "application/json"]
    }
}
