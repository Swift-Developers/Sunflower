//
//  SettingsAccountPgyerInfoView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import Cocoa

class SettingsAccountPgyerInfoView: NSView {

    @IBOutlet weak var keyLabel: NSTextField!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func set(key: String, name: String, password: String) {
        keyLabel.stringValue = key
        nameTextField.placeholderString = name
        passwordTextField.placeholderString = password
    }
}
