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
        guard let window = NSApplication.shared.mainWindow else {
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
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                switch value {
                case .ipa(let info):
                    // 选择平台
                    // 查询该平台下app列表
                    // 查找包名匹配的appid, 获取详情信息
                    let controller = PgyerIPAController.instance(file: url, with: info)
                    NSApplication.shared.mainWindow?.contentViewController = controller
                    
                case .apk(let info):
                    print(info)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ReceiveController: ReceiveDragViewDelegate {
    
    func draggingFileAccept(file url: URL) {
        handle(file: url)
    }
}
