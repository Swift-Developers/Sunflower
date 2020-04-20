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
    static func handle(file url: URL, with completion: @escaping ((Result<Info>) -> Void)) {
        guard url.isFileURL else {
            completion(.failure(.fileURLInvalid))
            return
        }
        
        switch Analysis(rawValue: url.pathExtension.lowercased()) {
        case .ipa:
            handleIPA(file: url) { result in
                completion(result.map { .ipa($0) })
            }
            
        case .apk:
            handleAPK(file: url) { result in
                completion(result.map { .apk($0) })
            }
            
        default:
            completion(.failure(.fileTypeInvalid))
        }
    }
}

extension Analysis {
    
    typealias Result<T> = Swift.Result<T, Analysis.Error>
    
    enum Info {
        case ipa(IPA)
        case apk(APK)
    }
    
    /// 解析异常
    enum Error: Swift.Error {
        case unknow(Swift.Error)    // 未知
        case fileURLInvalid         // 文件URL无效
        case fileTypeInvalid        // 文件类型无效
        case fileReadFailure        // 文件读取失败
        case ipa(IPA)
        case apk(APK)
        
        var localizedDescription: String {
            switch self {
            case .unknow(let error):
                return error.localizedDescription
            case .fileURLInvalid:
                return "文件URL无效"
            case .fileTypeInvalid:
                return "文件类型无效"
            case .fileReadFailure:
                return "文件读取失败"
            case .ipa(let error):
                return error.localizedDescription
            case .apk(let error):
                return error.localizedDescription
            }
        }
    }
}
