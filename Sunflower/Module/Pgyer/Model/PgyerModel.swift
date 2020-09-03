//
//  PgyerModel.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Foundation

class PgyerModel {
    
    typealias Detail = Pgyer.Detail
    typealias Info = Analysis.Info
    
    let account: Account.Pgyer
    let file: URL
    let info: Info
    
    private var cancellable: Cancellable?
    
    private var isRetry: Bool { Settings.isUploadRetry }
    
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
    func upload(_ notes: String,
                progress: @escaping ((Double) -> Void),
                with completion: @escaping ((API.Result<URL>) -> Void)) {
        
        struct Model: Codable {
            let buildShortcutUrl: String
        }
        
        cancellable?.cancel()
        cancellable = API.pgyer.load(
            .upload(.init(key: account.key, password: account.password, description: notes, file: file)),
            options: [.progress(progress)] + (isRetry ? [.retry(.force())] : [])
        ) { (result: API.Result<Model>) in
            guard !(result.error?.isRequestCancelled ?? false) else { return }
            switch result {
            case .success(let value):
                guard var url = URL(string: "https://www.pgyer.com") else {
                    return
                }
                url.appendPathComponent(value.buildShortcutUrl)
                completion(.success(url))
                
            case .failure(let error):
                guard !error.isRequestCancelled else { return }
                completion(.failure(error))
            }
        }
    }
    
    /// 取消上传
    func cancelUpload() {
        cancellable?.cancel()
    }
    
    /// 获取详情信息
    /// - Parameter completion: 完成回调
    func getDetail(with completion: @escaping ((API.Result<Detail?>) -> Void)) {
        getList { (result) in
            switch result {
            case .success(let value):
                let item = value.first(where: {
                    $0.buildType == self.info.type && $0.buildIdentifier == self.info.identifier
                })
                completion(.success(item))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getList(with completion: @escaping ((API.Result<[Detail]>) -> Void)) {
        struct Model: Codable {
            let list: [Detail]
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
