//
//  SettingsAccountFirimInfoView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import Cocoa

class SettingsAccountFirimInfoView: NSView {

    @IBOutlet weak var keyLabel: NSTextField!
    @IBOutlet weak var nameTextField: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func set(key: String, name: String) {
        keyLabel.stringValue = key
        nameTextField.placeholderString = name
    }
}
