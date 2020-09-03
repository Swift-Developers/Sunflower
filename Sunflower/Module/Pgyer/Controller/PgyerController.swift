//
//  PgyerController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Cocoa

class PgyerController: ViewController<NSView> {
    
    typealias Detail = PgyerModel.Detail
    
    private var model: PgyerModel!
    private var detail: Detail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var setNotes: ((String?) -> Void)
        
        switch model.info {
        case .ipa(let value):
            let controller = PgyerIPAController.instance(file: model.file, with: value)
            add(child: controller)
            controller.upload = upload
            setNotes = {
                controller.notes = $0 ?? ""
            }
            
        case .apk:
            setNotes = {
                print($0 ?? "")
            }
        }
        
        loadDetail { [weak self] (result) in
            guard let self = self else { return }
            setNotes(result?.buildUpdateDescription)
            self.detail = result
        }
    }
    
    private static func instance() -> Self {
        return StoryBoard.pgyer.instance()
    }
    
    static func instance(_ account: Account.Pgyer, file url: URL, with info: Analysis.Info) -> Self {
        let controller = instance()
        controller.model = .init(account, file: url, with: info)
        return controller
    }
}

extension PgyerController {
    
    private func loadDetail(with completion: @escaping ((Detail?) -> Void)) {
        model.getDetail { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                completion(value)
                
            case .failure:
                guard let window = self.view.window else { return }
                
                let alert = NSAlert()
                alert.addButton(withTitle: "重试")
                alert.addButton(withTitle: "取消")
                alert.messageText = "获取应用信息失败"
                alert.beginSheetModal(for: window) { [weak self] (response) in
                    guard let self = self else { return }
                    if response == .alertFirstButtonReturn {
                        self.loadDetail(with: completion)
                        
                    } else {
                        let controller = ReceiveController.instance()
                        self.view.window?.contentViewController = controller
                    }
                }
            }
        }
    }
    
    private func upload(_ source: PgyerIPAController, with notes: String) {
        Upload.prepare(in: self) { [weak self] result in
            guard let self = self else { return }
            self.uploading(source.info.name, notes, send: result)
        }
    }
    
    private func upload(_ source: PgyerAPKController, with notes: String) {
        
    }
    
    /// 上传中
    /// - Parameters:
    ///   - name: 应用名称
    ///   - notes: 更新记录
    ///   - notification: 通知配置
    private func uploading(_ name: String, _ notes: String, send notification: Upload.Notification) {
        let controller = UploadProcessController.instance()
        presentAsSheet(controller)
        controller.cancelled = { [weak self] in
            self?.model.cancelUpload()
        }
        controller.message = "准备完成 开始上传"
        
        model.upload(
            notes,
            progress: { progress in
                controller.message = "正在上传.."
                controller.progress = progress * 100
            },
            with: { [weak self] result in
                guard let self = self else { return }
                controller.dismiss(controller)
                
                switch result {
                case .success(let value):
                    let controller = UploadSuccessController.instance()
                    controller.url = value
                    controller.name = name
                    controller.notes = notes
                    controller.password = self.model.account.password
                    controller.local = notification.local
                    controller.robot = notification.robot
                    self.presentAsSheet(controller)
                    
                case .failure(let error):
                    let controller = UploadFailureController.instance()
                    self.presentAsSheet(controller)
                    controller.message = error.description
                    controller.retry = { [weak self] in
                        guard let self = self else { return }
                        self.uploading(name, notes, send: notification)
                    }
                }
            }
        )
    }
}
