//
//  SettingsAccountController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences

class SettingsAccountController: ViewController<SettingsAccountView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsAccountController: PreferencePane {
        
    var preferencePaneIdentifier: Identifier { .account }
        
    var preferencePaneTitle: String { "账号" }
    
    var toolbarItemIcon: NSImage { NSImage.init(named: NSImage.userAccountsName) ?? .init() }
}
