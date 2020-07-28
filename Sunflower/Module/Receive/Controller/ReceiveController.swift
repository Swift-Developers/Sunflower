//
//  ReceiveController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Cocoa
import AttributedString

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
        Analysis.handle(file: url) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.handle(file: url, with: value)
                
            case .failure(let error):
                guard let window = NSApp.mainWindow else { return }
                
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "异常"
                alert.informativeText = error.localizedDescription
                alert.beginSheetModal(for: window)
            }
        }
    }
    
    private func handle(file url: URL, with info: Analysis.Info) {
        guard let window = NSApp.mainWindow else { return }
        
        // 选择账号
        // 查询该账号平台下app列表
        // 查找包名匹配的appid, 获取详情信息
        
        Account.select(in: self) { (account) in
            switch account {
            case .pgyer(let account):
                let controller = PgyerController.instance(account, file: url, with: info)
                window.contentViewController = controller
                
            case .firim:
                break
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
