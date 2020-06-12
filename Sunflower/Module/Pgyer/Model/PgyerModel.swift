//
//  PgyerModel.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Foundation

class PgyerModel {
    
    typealias Info = Analysis.Info
    
    let account: Account.Pgyer
    let file: URL
    let info: Info
    
    private var cancellable: Cancellable?
    
    init(_ account: Account.Pgyer, file url: URL, with info: Info) {
        self.account = account
        self.file = url
        self.info = info
    }
    
    /// 上传
    /// - Parameters:
    ///   - notes: 更新记录
    ///   - progress: 进度回调
    ///   - completion: 完成回调
    func upload(_ notes: String, progress: @escaping ((Double) -> Void), with completion: @escaping ((Bool) -> Void)) {
        cancellable?.cancel()
        cancellable = API.pgyer.load(
            .upload(.init(key: account.key, password: account.password, description: notes, file: file)),
            options: [.progress(progress)]
        ) { (result) in
            completion(result)
        }
    }
    
    /// 取消上传
    func cancelUpload() {
        cancellable?.cancel()
    }
    
    func getDetail(with completion: @escaping ((API.Result<Item?>) -> Void)) {
        getList { (result) in
            switch result {
            case .success(let value):
                let item = value.first(where: { $0.buildType == self.info.type && $0.buildIdentifier == self.info.identifier })
                completion(.success(item))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getList(with completion: @escaping ((API.Result<[Item]>) -> Void)) {
        struct Model: Codable {
            let list: [Item]
        }
        API.pgyer.load(.list(key: account.key), options: []) { (result: API.Result<Model>) in
            switch result {
            case .success(let value):
                completion(.success(value.list))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension PgyerModel {
    
    struct Item: Codable {
        let appKey: String
        let buildKey: String
        let buildType: String
        let buildName: String
        let buildVersion: String
        let buildIdentifier: String
        let buildUpdateDescription: String
        let buildCreated: String
    }
}

fileprivate extension Analysis.Info {
    
    /// 类型 1 iOS, 2 Android
    var type: String {
        switch self {
        case .ipa:  return "1"
        case .apk:  return "2"
        }
    }
    
    /// 包名
    var identifier: String {
        switch self {
        case let .ipa(value):  return value.bundleId
        case let .apk(value):  return value.package
        }
    }
}
