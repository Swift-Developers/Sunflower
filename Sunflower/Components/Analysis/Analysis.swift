//
//  Analysis.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Foundation

enum Analysis: String, CaseIterable {
    case ipa
    case apk
}

extension Analysis {
    
    /// 解析处理
    /// - Parameters:
    ///   - url: 文件URL
    ///   - completion: 完成回调 (包名)
    static func handle(file url: URL, with completion: @escaping ((Result<String>) -> Void)) {
        guard url.isFileURL else {
            completion(.failure(.fileURLInvalid))
            return
        }
        
        switch Analysis(rawValue: url.pathExtension.lowercased()) {
        case .ipa:
            handleIPA(file: url) { result in
                completion(result.map { $0.bundleId })
            }
            
        case .apk:
            handleAPK(file: url) { result in
                completion(result.map { $0.name })
            }
            
        default:
            completion(.failure(.fileTypeInvalid))
        }
    }
}

extension Analysis {
    
    typealias Result<T> = Swift.Result<T, Analysis.Error>
    
    /// 解析异常
    enum Error: Swift.Error {
        case unknow
        case fileURLInvalid
        case fileTypeInvalid
        case fileReadFailure
        case ipa(IPA)
        case apk(APK)
    }
}
