import Foundation
import CryptoSwift

public protocol UserDefaultsSettable {
    associatedtype Keys: UserDefaultsSettableKeys
}

public protocol UserDefaultsSettableKeys: Swift.RawRepresentable {
    var token: String? { get }
    var build: String? { get }
}

public extension UserDefaultsSettableKeys where RawValue == String {
    var token: String? { return nil }
    var build: String? { return nil }
}

public extension UserDefaultsSettable where Keys.RawValue == String {
    
    private static func forKey(_ key: Keys) -> String {
        var string = String(format: "%@_%@", arguments: [String(describing: self), key.rawValue])
        if let token = key.token {
            string += String(format: "_%@", token)
        }
        if let build = key.build {
            string += String(format: "_%@", build)
        }
        return string.md5()
    }
    
    private static var keys: Set<String> {
        get {
            let key = String(describing: self) + "_keys"
            return Set(UserDefaults.standard.stringArray(forKey: key.md5()) ?? [])
        }
        set {
            let key = String(describing: self) + "_keys"
            UserDefaults.standard.set(Array(newValue), forKey: key.md5())
        }
    }
    
    /// setter
    
    static func set(_ value: String?, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: Bool, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: Int, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: Float, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: Double, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: URL?, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set(_ value: Any?, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(value, forKey: key)
        keys.insert(key)
    }
    
    static func set<T: Encodable>(model: T?, forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.set(model: model, forKey: key)
        keys.insert(key)
    }
    
    /// getter
    
    static func string(forKey key: Keys) -> String? {
        return UserDefaults.standard.string(forKey: forKey(key))
    }
    
    static func bool(forKey key: Keys) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey(key))
    }
    
    static func integer(forKey key: Keys) -> Int {
        return UserDefaults.standard.integer(forKey: forKey(key))
    }
    
    static func float(forKey key: Keys) -> Float {
        return UserDefaults.standard.float(forKey: forKey(key))
    }
    
    static func double(forKey key: Keys) -> Double {
        return UserDefaults.standard.double(forKey: forKey(key))
    }
    
    static func url(forKey key: Keys) -> URL? {
        return UserDefaults.standard.url(forKey: forKey(key))
    }
    
    static func object(forKey key: Keys) -> Any? {
        return UserDefaults.standard.object(forKey: forKey(key))
    }
    
    static func model<T: Decodable>(forKey key: Keys) -> T? {
        return UserDefaults.standard.model(forKey: forKey(key))
    }
    
    /// remove
    
    static func remove(forKey key: Keys) {
        let key = forKey(key)
        UserDefaults.standard.removeObject(forKey: key)
        keys.remove(key)
    }
    
    static func removeAll() {
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        keys.removeAll()
    }
}

public extension UserDefaultsSettable where Keys.RawValue == String {
    
    static func observe(forKey key: Keys, change: @escaping (Any?, Any?) -> Void) -> UserDefaultsObservation {
        return UserDefaultsObservation(key: forKey(key), onChange: change)
    }
    
    static func observe<Old, New>(forKey key: Keys, change: @escaping (Old?, New?) -> Void) -> UserDefaultsObservation {
        return UserDefaultsObservation(key: forKey(key)) { old, new in
            change(old as? Old, new as? New)
        }
    }
    
    static func observe<T: Decodable>(forKey key: Keys, change: @escaping (T?, T?) -> Void) -> UserDefaultsObservation {
        return UserDefaultsObservation(key: forKey(key)) { old, new in
            change((try? JSONDecoder().decode(T.self, from: old as? Data ?? .init())) ?? old as? T,
                   (try? JSONDecoder().decode(T.self, from: new as? Data ?? .init())) ?? new as? T)
        }
    }
}

private extension UserDefaults {
    
     func model<T: Decodable>(forKey key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    func set<T: Encodable>(model: T?, forKey key: String) {
        if let model = model {
            let encoded = try? JSONEncoder().encode(model)
            UserDefaults.standard.set(encoded, forKey: key)
            
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

public class UserDefaultsObservation: NSObject {
    let key: String
    private var onChange: (Any?, Any?) -> Void
    
    init(key: String, onChange: @escaping (Any?, Any?) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key, options: [.old, .new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil else { return }
        onChange(change[.oldKey], change[.newKey])
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key, context: nil)
    }
}
