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
    ///   - completion: 完成回调
    func handle(file url: URL, with completion: @escaping ((Result) -> Void)) {
        switch self {
        case .ipa:
            handleIPA(file: url, with: completion)
        case .apk:
            handleAPK(file: url, with: completion)
        }
    }
}

extension Analysis {
    
    struct Info {
        let id: String  // 包名
        let url: String // 本地路径
    }
}

extension Analysis {
    
    typealias Result = Swift.Result<Analysis.Value, Analysis.Error>
    
    /// 解析结果
    enum Value {
        case ipa(IPA)
        case apk(APK)
    }
    
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
