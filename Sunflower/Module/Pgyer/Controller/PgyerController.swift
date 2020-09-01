//
//  PgyerController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Cocoa

class PgyerController: ViewController<NSView> {
    
    private var model: PgyerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch model.info {
        case .ipa(let value):
            let controller = PgyerIPAController.instance(file: model.file, with: value)
            add(child: controller)
            controller.upload = upload
            getNotes {
                controller.notes = $0 ?? ""
            }
            
        case .apk:
            break
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
    
    private func getNotes(with completion: @escaping ((String?) -> Void)) {
        model.getDetail { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                completion(value?.buildUpdateDescription)
                
            case .failure:
                guard let window = NSApp.mainWindow else { return }
                
                let alert = NSAlert()
                alert.addButton(withTitle: "重试")
                alert.addButton(withTitle: "取消")
                alert.messageText = "获取应用信息失败"
                alert.beginSheetModal(for: window) { [weak self] (response) in
                    guard let self = self else { return }
                    if response == .alertFirstButtonReturn {
                        self.getNotes(with: completion)
                        
                    } else {
                        let controller = ReceiveController.instance()
                        NSApp.mainWindow?.contentViewController = controller
                    }
                }
            }
        }
    }
    
    private func upload(_ source: PgyerIPAController, with notes: String) {
        let controller = UploadProcessAlertController.instance()
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
                    let controller = UploadSuccessAlertController.instance()
                    self.presentAsSheet(controller)
                    controller.url = value

                case .failure(let error):
                    let controller = UploadFailureAlertController.instance()
                    self.presentAsSheet(controller)
                    controller.message = error.description
                    controller.retry = { [weak self] in
                        guard let self = self else { return }
                        self.upload(source, with: notes)
                    }
                }
            }
        )
    }
    
    private func upload(_ source: PgyerAPKController, with notes: String) {
        
    }
}
