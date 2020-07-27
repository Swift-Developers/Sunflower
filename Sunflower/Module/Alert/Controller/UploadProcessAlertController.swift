//
//  UploadProcessAlertController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa

class UploadProcessAlertController: ViewController<NSView> {
    
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var messageLabel: NSTextField!
    
    var progress: Double {
        get { progressIndicator.doubleValue }
        set { progressIndicator.doubleValue = newValue }
    }
    
    var max: Double {
        get { progressIndicator.maxValue }
        set { progressIndicator.maxValue = newValue }
    }
    
    var min: Double {
        get { progressIndicator.minValue }
        set { progressIndicator.minValue = newValue }
    }
    
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    
    var cancelled: (() -> Void)?
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(self)
        cancelled?()
    }
    
    static func instance() -> Self {
        return StoryBoard.alert.instance()
    }
}
