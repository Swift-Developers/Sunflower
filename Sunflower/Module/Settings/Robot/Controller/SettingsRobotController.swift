//
//  SettingsRobotController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences
import DifferenceKit

class SettingsRobotController: ViewController<SettingsRobotView> {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsRobotController: PreferencePane {
    
    var preferencePaneIdentifier: Identifier { .robot }
    
    var preferencePaneTitle: String { "机器人" }
    
    var toolbarItemIcon: NSImage { NSImage(named: NSImage.advancedName) ?? .init() }
}
