//
//  UploadSuccessAlertController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa

class UploadSuccessAlertController: ViewController<NSView> {

    @IBOutlet private weak var messageLabel: NSTextField!
    
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func detailAction(_ sender: Any) {
        guard let url = url else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(self)
        
        let controller = ReceiveController.instance()
        NSApp.mainWindow?.contentViewController = controller
    }
    
    static func instance() -> Self {
        return StoryBoard.alert.instance()
    }
}
