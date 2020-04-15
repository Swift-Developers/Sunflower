//
//  Analysis+APK.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Foundation
import AXML

extension Analysis {
    
    struct APK {
        let name: String
        let versionCode: String
        let versionName: String
        let compileSdkVersionCode: String
        let compileSdkVersionName: String
        let platformBuildVersionCode: String
        let platformBuildVersionName: String
        let minSdkVersion: String
        let targetSdkVersion: String
    }
}

extension Analysis.Error {

    enum APK {
        case unzip
        case manifest
        case axml
    }
}

extension Analysis {
    
    /// 解析处理 IPA
    /// - Parameters:
    ///   - url: 文件URL
    ///   - completion: 完成回调
    static func handleAPK(file url: URL, with completion: @escaping ((Result<APK>) -> Void)) {
        guard url.isFileURL else {
            completion(.failure(.fileURLInvalid))
            return
        }
        guard url.pathExtension.lowercased() == Analysis.apk.rawValue else {
            completion(.failure(.fileTypeInvalid))
            return
        }
        
        unzip(file: url) { (result) in
            switch result {
            case .success(let url):
                self.info(file: url, with: completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func unzip(file url: URL, with completion: @escaping ((Swift.Result<URL, Error>) -> Void)) {
        let working = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("analysis.apk.cache")
        let manifest = working.appendingPathComponent("AndroidManifest.xml")
        // 清理工作路径
        try? FileManager.default.removeItem(at: working)
        
        do {
            let bin = URL(fileURLWithPath: "/usr/bin/unzip")
            let process = Process()
            process.executableURL = bin
            process.arguments = ["-q", url.path, "-d", working.path]
            try process.run()
            process.waitUntilExit()
            
            guard FileManager.default.fileExists(atPath: manifest.path) else {
                completion(.failure(.apk(.manifest)))
                return
            }
            completion(.success(manifest))
            
        } catch {
            completion(.failure(.ipa(.unzip)))
        }
    }
    
    private static func info(file url: URL, with completion: @escaping ((Result<APK>) -> Void)) {
        
        struct Model: Codable {
            let name: String
            let versionCode: String
            let versionName: String
            let compileSdkVersionCode: String
            let compileSdkVersionName: String
            let platformBuildVersionCode: String
            let platformBuildVersionName: String
            let minSdkVersion: String
            let targetSdkVersion: String
            
            enum CodingKeys: String, CodingKey {
                case name = "package"
                case versionCode = "android:versionCode"
                case versionName = "android:versionName"
                case compileSdkVersionCode = "android:compileSdkVersion"
                case compileSdkVersionName = "android:compileSdkVersionCodename"
                case platformBuildVersionCode = "platformBuildVersionCode"
                case platformBuildVersionName = "platformBuildVersionName"
                case minSdkVersion = "android:minSdkVersion"
                case targetSdkVersion = "android:targetSdkVersion"
            }
        }
        
        do {
            let data = try Data(contentsOf: url)
            let xml = XMLParser(data: try axmlToXml(data))
            let parser = ManifestParser()
            xml.delegate = parser
            xml.parse()
            let json = try JSONSerialization.data(withJSONObject: parser.info, options: .prettyPrinted)
            let model = try JSONDecoder().decode(Model.self, from: json)
            
            completion(
                .success(
                    .init(
                        name: model.name,
                        versionCode: model.versionCode,
                        versionName: model.versionName,
                        compileSdkVersionCode: model.compileSdkVersionCode,
                        compileSdkVersionName: model.compileSdkVersionName,
                        platformBuildVersionCode: model.platformBuildVersionCode,
                        platformBuildVersionName: model.platformBuildVersionName,
                        minSdkVersion: model.minSdkVersion,
                        targetSdkVersion: model.targetSdkVersion
                    )
                )
            )
            
        } catch {
            completion(.failure(.apk(.axml)))
        }
    }
}

fileprivate class ManifestParser: NSObject, XMLParserDelegate {
    var info: [String: String] = [:]
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "manifest" {
            info.merge(attributeDict)
        }
        if elementName == "uses-sdk" {
            info.merge(attributeDict)
        }
    }
}

fileprivate extension Dictionary {
    
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
            for (k ,v) in other {
                self[k] = v
        }
    }
}
