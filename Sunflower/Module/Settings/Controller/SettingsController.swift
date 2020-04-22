//
//  SettingsController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences

class SettingsController: ViewController<SettingsView> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func appearanceAction(_ sender: NSButton) {
        switch sender.tag {
        case 0:     Appearance.current = .aqua
        case 1:     Appearance.current = .dark
        case 2:     Appearance.current = .auto
        default: break
        }
        container.set(appearance: Appearance.current)
    }
    
    @IBAction func statusBarAction(_ sender: NSPopUpButton) {
        
    }

    @IBAction func uploadRetryAction(_ sender: NSButton) {
        
    }
    
    @IBAction func uploadNotificationAction(_ sender: NSButton) {
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsController: PreferencePane {
    
    var preferencePaneIdentifier: Identifier { .general }
    
    var preferencePaneTitle: String { "通用" }
    
    var toolbarItemIcon: NSImage { NSImage.init(named: NSImage.preferencesGeneralName) ?? .init() }
}
