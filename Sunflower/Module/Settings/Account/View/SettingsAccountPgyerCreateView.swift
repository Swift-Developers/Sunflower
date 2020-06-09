//
//  SettingsAccountPgyerCreateView.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class SettingsAccountPgyerCreateView: NSView {

    var key: String {
        keyTextField.stringValue
    }
    
    var name: String {
        nameTextField.stringValue
    }
    
    var password: String {
        passwordTextField.stringValue
    }
    
    @IBOutlet private weak var keyTextField: NSTextField!
    @IBOutlet private weak var nameTextField: NSTextField!
    @IBOutlet private weak var passwordTextField: NSTextField!
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldChanged),
            name: NSControl.textDidChangeNotification,
            object: passwordTextField
        )
    }
    
    @objc
    private func textFieldChanged(_ sender: Notification) {
        createButton.isEnabled = !keyTextField.stringValue.isEmpty && !nameTextField.stringValue.isEmpty &&
            !passwordTextField.stringValue.isEmpty
    }
}
