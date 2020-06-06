//
//  PgyerModel.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Foundation

class PgyerModel {
    
    typealias Info = Analysis.Info
    
    let key: String
    let file: URL
    let info: Info
    
    init(_ key: String, file url: URL, with info: Info) {
        self.key = key
        self.file = url
        self.info = info
    }
    
    func upload(_ notes: String, with completion: @escaping ((Bool) -> Void)) {
        API.pgyer.load(.upload(.init(password: "", description: notes, file: file)), options: [.retry(.count(3))]) { (result) in
            completion(result)
        }
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
        API.pgyer.load(.list(key: key), options: []) { (result: API.Result<Model>) in
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
