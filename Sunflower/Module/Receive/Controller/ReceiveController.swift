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
        // Do view setup here.
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
        panel.beginSheetModal(for: window) { (response) in
            switch response {
            case .OK:
                guard let url = panel.url else {
                    return
                }
                Analysis.ipa.handle(file: url) { (result) in
                    
                }
                
            default: break
            }
        }
        
    }
    
    static func instance() -> Self {
        return StoryBoard.receive.instance()
    }
}
