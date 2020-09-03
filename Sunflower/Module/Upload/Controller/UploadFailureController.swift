//
//  UploadFailureController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa

class UploadFailureController: ViewController<NSView> {

    @IBOutlet private weak var messageLabel: NSTextField!
    
    /// 提示消息
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    /// 重试回调
    var retry: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        dismiss(self)
        retry?()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(self)
    }
    
    static func instance() -> Self {
        return StoryBoard.upload.instance()
    }
}
