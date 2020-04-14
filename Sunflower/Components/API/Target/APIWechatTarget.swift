import Moya

extension API {
    static let wechat = MoyaProvider<APIWechatTarget>(plugins: plugins)
}

enum APIWechatTarget {
    /// 发送消息
    case sendText(key: String, content: String, at: [String])
    /// 发送图片  content base64编码
    case sendImage(key: String, content: String, md5: String)
}

extension APIWechatTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://qyapi.weixin.qq.com/cgi-bin/webhook")!
    }
    
    var path: String {
        switch self {
        case .sendText:
            return "send"
        case .sendImage:
            return "send"
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
        case let .sendText(key, content, at):
            let body: [String: Any] = ["msgtype": "text", "text": ["content": content, "mentioned_mobile_list": at]]
            return .requestCompositeParameters(
                bodyParameters: body,
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["key": key]
            )
        case let .sendImage(key, content, md5):
            let body: [String: Any] = ["msgtype": "image", "image": ["base64": content, "md5": md5]]
            return .requestCompositeParameters(
                bodyParameters: body,
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["key": key]
            )
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        return ["content-Type": "application/json"]
    }
}
