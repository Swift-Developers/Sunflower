//
//  Analysis+IPA.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import AppKit

extension Analysis {
    
    struct IPA {
        let icon: NSImage
        let name: String
        let version: String
        let bundleId: String
        let bundleName: String
        let bundleVersion: String
        let creationDate: Date
    }
}

extension Analysis.Error {
    
    enum IPA {
        case unzip
        case payload
        case plist
        case app
    }
}

extension Analysis {
    
    /// 解析处理 IPA
    /// - Parameters:
    ///   - url: 文件URL
    ///   - completion: 完成回调
    static func handleIPA(file url: URL, with completion: @escaping ((Result<IPA>) -> Void)) {
        guard url.isFileURL else {
            completion(.failure(.fileURLInvalid))
            return
        }
        guard url.pathExtension.lowercased() == Analysis.ipa.rawValue else {
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
        let working = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("analysis.ipa.cache")
        let payload = working.appendingPathComponent("Payload")
        // 清理工作路径
        try? FileManager.default.removeItem(at: working)
        
        do {
            let bin = URL(fileURLWithPath: "/usr/bin/unzip")
            let process = Process()
            process.executableURL = bin
            process.arguments = ["-q", url.path, "-d", working.path]
            try process.run()
            process.waitUntilExit()
            
            guard FileManager.default.fileExists(atPath: payload.path) else {
                completion(.failure(.ipa(.payload)))
                return
            }
            completion(.success(payload))
            
        } catch {
            completion(.failure(.ipa(.unzip)))
        }
    }
    
    private static func info(file url: URL, with completion: @escaping ((Result<IPA>) -> Void)) {
        
        struct InfoPlist: Codable {
            let name: String
            let version: String
            let bundleId: String
            let bundleName: String
            let bundleVersion: String
            
            enum CodingKeys: String, CodingKey {
                case name = "CFBundleDisplayName"
                case version = "CFBundleShortVersionString"
                case bundleId = "CFBundleIdentifier"
                case bundleName = "CFBundleName"
                case bundleVersion = "CFBundleVersion"
            }
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [])
            guard let app = contents.filter({ $0.pathExtension.lowercased() == "app" }).first else {
                completion(.failure(.ipa(.app)))
                return
            }
            let data = try Data(contentsOf: app.appendingPathComponent("Info.plist"))
            let icon = NSImage(contentsOf: app.appendingPathComponent("AppIcon60x60@2x.png"))
            let info = try PropertyListDecoder().decode(InfoPlist.self, from: data)
            let date = try FileManager.default.attributesOfItem(atPath: app.path)[.creationDate] as? Date
            
            completion(
                .success(
                    .init(
                        icon: icon ?? .init(),
                        name: info.name,
                        version: info.version,
                        bundleId: info.bundleId,
                        bundleName: info.bundleName,
                        bundleVersion: info.bundleVersion,
                        creationDate: date ?? .distantPast
                    )
                )
            )
            
        } catch {
            completion(.failure(.ipa(.plist)))
        }
    }
}
