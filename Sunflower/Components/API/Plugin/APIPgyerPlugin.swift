import Moya

class APIPgyerPlugin: PluginType {
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: Moya.TargetType) -> Result<Moya.Response, MoyaError> {
        switch result {
        case .success(let value):
            do {
                guard let temp = try value.mapJSON(failsOnEmptyData: false) as? [AnyHashable: Any] else {
                    return .failure(.jsonMapping(value))
                }
                
                var final: [AnyHashable: Any] = [:]
                final["code"] = to(code: temp["code"])
                final["msg"] = temp["message"] as? String ?? ""
                final["data"] = temp["data"]
                
                return .success(
                    .init(
                        statusCode: value.statusCode,
                        data: final.jsonData() ?? Data(),
                        request: value.request,
                        response: value.response
                    )
                )
                
            } catch {
                return .failure(.objectMapping(error, value))
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func to(code value: Any?) -> Int {
        guard let value = value as? Int else {
            return -1
        }
    
        switch value {
        case 0:             return 0    // 成功
        case 1001, 1002:    return -3   // 鉴权
        default:            return -1   // 其他
        }
    }
}
