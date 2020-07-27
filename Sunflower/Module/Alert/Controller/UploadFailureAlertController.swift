//
//  UploadFailureAlertController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa

class UploadFailureAlertController: ViewController<NSView> {

    @IBOutlet private weak var messageLabel: NSTextField!
    
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    
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
        return StoryBoard.alert.instance()
    }
}
