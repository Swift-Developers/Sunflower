import Foundation

extension API {
    public typealias Result<T> = Swift.Result<T, API.Error>
    public struct Null: Codable {}
}
