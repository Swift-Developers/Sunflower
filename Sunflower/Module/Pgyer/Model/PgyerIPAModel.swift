//
//  PgyerIPAModel.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Foundation

class PgyerIPAModel {
    
    typealias Info = Analysis.IPA
    
    let key: String
    let info: Info
    
    init(_ key: String, info: Info) {
        self.key = key
        self.info = info
    }
    
    func upload(file url: URL) {
        
    }
    
    func getUpdateDescription() -> String? {
        getList { (result) in
           let item = result.first(where: { $0.buildType == "1" && $0.buildIdentifier == self.info.bundleId })
            
        }
        return ""
    }
    
    private func getList(with completion: @escaping (([Item]) -> Void)) {
        struct Model: Codable {
            let list: [Item]
        }
        API.pgyer.load(.list(key: key), options: []) { (result: API.Result<Model>) in
            switch result {
            case .success(let value):
                completion(value.list)
                
            case .failure:
                completion([])
            }
        }
    }
}

extension PgyerIPAModel {
    
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
