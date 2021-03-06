//
//  SettingsRobotWechatCreateView.swift
//  Sunflower
//
//  Created by Lee on 2020/7/28.
//

import Cocoa

class SettingsRobotWechatCreateView: NSView {

    var key: String {
        keyTextField.stringValue
    }
    
    var name: String {
        nameTextField.stringValue
    }
    
    @IBOutlet private weak var keyTextField: NSTextField!
    @IBOutlet private weak var nameTextField: NSTextField!
    @IBOutlet private weak var createButton: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldChanged),
            name: NSControl.textDidChangeNotification,
            object: keyTextField
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldChanged),
            name: NSControl.textDidChangeNotification,
            object: nameTextField
        )
    }
    
    @objc
    private func textFieldChanged(_ sender: Notification) {
        createButton.isEnabled = !keyTextField.stringValue.isEmpty && !nameTextField.stringValue.isEmpty
    }
}
