//
//  ReceiveController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Cocoa

class ReceiveController: ViewController<ReceiveView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        container.dragView.delegate = self
    }
    
    @IBAction func addAction(_ sender: NSButton) {
        guard let window = NSApp.mainWindow else {
            return
        }
        
        let panel = NSOpenPanel()
        panel.prompt = "打开"
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = Receive.types
        panel.beginSheetModal(for: window) { [weak self] (response) in
            guard let self = self else { return }
            guard response == .OK else { return }
            guard let url = panel.url else { return }
            
            self.handle(file: url)
        }
    }
    
    static func instance() -> Self {
        return StoryBoard.receive.instance()
    }
}

extension ReceiveController {
    
    private func handle(file url: URL) {
        Analysis.handle(file: url) { (result) in
            guard let window = NSApp.mainWindow else { return }
            
            switch result {
            case .success(let value):
                switch value {
                case .ipa(let info):
                    // 选择平台
                    // 查询该平台下app列表
                    // 查找包名匹配的appid, 获取详情信息
                    let controller = SinglePickerController.instance(
                        Account.allCases.map({ .init(icon: $0.icon, name: $0.name) })
                    )
                    controller.completion = { [weak self] index in
                        switch Account.allCases[index] {
                        case .pgyer:
                            let controller = PgyerIPAController.instance(file: url, with: info)
                            window.contentViewController = controller
                            
                        case .firim:
                            break
                        }
                    }
                    self.presentAsSheet(controller)
                    
                case .apk(let info):
                    print(info)
                }
                
            case .failure(let error):
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "异常"
                alert.informativeText = error.localizedDescription
                alert.beginSheetModal(for: window)
            }
        }
    }
}

extension ReceiveController: ReceiveDragViewDelegate {
    
    func draggingFileAccept(file url: URL) {
        handle(file: url)
    }
}

fileprivate extension Account {
    
    var name: String {
        switch self {
        case .pgyer:    return "蒲公英"
        case .firim:    return "fir.im"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .pgyer:    return #imageLiteral(resourceName: "platform_icon_pgyer")
        case .firim:    return #imageLiteral(resourceName: "platform_icon_firim")
        }
    }
}
