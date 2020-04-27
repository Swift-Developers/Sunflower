//
//  Analysis+IPA.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import AppKit

extension Analysis {
    
    struct IPA {
        let icon: NSImage?              // 图标
        let name: String                // 名称
        let version: String             // 版本
        let bundleId: String            // 标识
        let bundleName: String          // 包名
        let bundleVersion: String       // 编译版本
        let creationDate: Date?         // 创建时间
        
        let embedded: Embedded?         // 描述文件
    }
}

extension Analysis.IPA {
    
    struct Embedded: Codable {
        let name: String                // 描述文件名称
        let appIDName: String           // 应用ID名称
        let appIDPrefix: [String]       // 应用ID前缀
        let teamID: [String]            // 团队ID
        let teamName: String            // 团队名称
        let platform: [String]          // 支持平台
        
        let creationDate: Date          // 证书创建时间
        let expirationDate: Date        // 证书到期时间
        
        let devices: [String]?          // UDID
        
        let UUID: String                // UUID
    }
}

extension Analysis.Error {
    
    enum IPA: Swift.Error {
        case unzip              // 解压失败
        case payload            // 应用文件
        case plist              // 应用配置
        case embedded           // 描述文件
        
        var localizedDescription: String {
            switch self {
            case .unzip:
                return "解压失败"
            case .payload:
                return "应用文件获取失败"
            case .plist:
                return "应用配置解析失败"
            case .embedded:
                return "描述文件解析失败"
            }
        }
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
    
    private static func embedded(file url: URL, with completion: @escaping ((Result<IPA.Embedded>) -> Void)) {
        
        struct Embedded: Codable {
            let name: String                // 描述文件名称
            let appIDName: String           // 应用ID名称
            let appIDPrefix: [String]       // 应用ID前缀
            let teamID: [String]            // 团队ID
            let teamName: String            // 团队名称
            let platform: [String]          // 支持平台
            
            let creationDate: Date          // 证书创建时间
            let expirationDate: Date        // 证书到期时间
            
            let devices: [String]?          // UDID
            
            let UUID: String                // UUID
            
            enum CodingKeys: String, CodingKey {
                case name = "Name"
                case appIDName = "AppIDName"
                case appIDPrefix = "ApplicationIdentifierPrefix"
                case teamID = "TeamIdentifier"
                case teamName = "TeamName"
                case platform = "Platform"
                case creationDate = "CreationDate"
                case expirationDate = "ExpirationDate"
                case devices = "ProvisionedDevices"
                case UUID = "UUID"
            }
        }
        // http://maniak-dobrii.com/extracting-stuff-from-provisioning-profile/
        do {
            let input = url.appendingPathComponent("embedded.mobileprovision")
            let output = url.appendingPathComponent("embedded.plist")
            let bin = URL(fileURLWithPath: "/usr/bin/security")
            let process = Process()
            process.executableURL = bin
            process.arguments = ["cms", "-D", "-i", input.path, "-o", output.path]
            try process.run()
            process.waitUntilExit()
            
            guard FileManager.default.fileExists(atPath: output.path) else {
                completion(.failure(.ipa(.embedded)))
                return
            }
            let data = try Data(contentsOf: output)
            let model = try PropertyListDecoder().decode(Embedded.self, from: data)
            
            completion(
                .success(
                    .init(
                        name: model.name,
                        appIDName: model.appIDName,
                        appIDPrefix: model.appIDPrefix,
                        teamID: model.teamID,
                        teamName: model.teamName,
                        platform: model.platform,
                        creationDate: model.creationDate,
                        expirationDate: model.expirationDate,
                        devices: model.devices,
                        UUID: model.UUID
                    )
                )
            )
            
        } catch {
            completion(.failure(.ipa(.embedded)))
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
                completion(.failure(.ipa(.plist)))
                return
            }
            let data = try Data(contentsOf: app.appendingPathComponent("Info.plist"))
            let icon = NSImage(contentsOf: app.appendingPathComponent("AppIcon60x60@2x.png"))
            let info = try PropertyListDecoder().decode(InfoPlist.self, from: data)
            let date = try FileManager.default.attributesOfItem(atPath: app.path)[.creationDate] as? Date
            
            embedded(file: app) { result in
                switch result {
                case .success(let value):
                    completion(
                        .success(
                            .init(
                                icon: icon,
                                name: info.name,
                                version: info.version,
                                bundleId: info.bundleId,
                                bundleName: info.bundleName,
                                bundleVersion: info.bundleVersion,
                                creationDate: date,
                                embedded: value
                            )
                        )
                    )
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        } catch {
            completion(.failure(.ipa(.plist)))
        }
    }
}
