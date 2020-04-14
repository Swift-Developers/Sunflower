extension Result {
    
    public var value: Success? {
        switch self {
        case .success(let value):   return value
        case .failure:              return nil
        }
    }
    
    public var error: Failure? {
        switch self {
        case .failure(let error):   return error
        case .success:              return nil
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .success:              return true
        case .failure:              return false
        }
    }
}
