import Moya

class APIAdaptationPlugin: PluginType {
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: Moya.TargetType) -> Result<Moya.Response, MoyaError> {
        switch result {
        case .success(let value):
            do {
                guard let temp = try value.mapJSON(failsOnEmptyData: false) as? [AnyHashable: Any] else {
                    return .failure(.jsonMapping(value))
                }
                
                var final: [AnyHashable: Any] = [:]
                final["code"] = temp["code"]
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
}
