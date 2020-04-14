import Moya

class APITimeoutPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        var request = request
        
        request.timeoutInterval = 30
        
        return request
    }
}
