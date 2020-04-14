//
//  Analysis+APK.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Foundation

extension Analysis {
    
    struct APK {
        let url: URL
        let info: Info
        
        struct Info {
            let name: String
            let versionCode: String
            let versionName: String
            let sdkVerison: String
            let permission: [String]
        }
    }
}

extension Analysis.Error {

    enum APK {
        case aapt
    }
}

extension Analysis {
    
    func handleAPK(file url: URL, with completion: @escaping ((Result) -> Void)) {
        guard url.isFileURL else {
            completion(.failure(.fileURLInvalid))
            return
        }
        guard url.pathExtension.lowercased() == "apk" else {
            completion(.failure(.fileTypeInvalid))
            return
        }
        
        
    }
}
