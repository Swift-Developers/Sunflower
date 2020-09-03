import Moya

extension API {
    
    static let feishu = MoyaProvider<APIFeishuTarget>(plugins: plugins)
}

enum APIFeishuTarget {
    /// 发送消息
    case sendText(key: String, title: String, content: String, url: String?)
}

// https://getfeishu.cn/hc/zh-cn/articles/360024984973-在群聊中使用机器人

extension APIFeishuTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://open.feishu.cn/open-apis/bot/v2/hook")!
    }
    
    var path: String {
        switch self {
        case let .sendText(key, _, _, _):
            return "\(key)"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return .init()
    }
    
    var task: Task {
        switch self {
        case let .sendText(_, title, content, url):
            let body: [String: Any] = [
                "msg_type": "post",
                "content": [
                    "post": [
                        "zh_cn": [
                            "title": title,
                            "content": [
                                [
                                    ["tag": "text", "text": content]
                                ],
                                [
                                    ["tag": "text", "text": "安装地址: "],
                                    ["tag": "a", "text": "点击安装", "href": url ?? ""]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
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
