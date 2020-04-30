//
//  SettingsAccountFirimInfoController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import Cocoa

class SettingsAccountFirimInfoController: ViewController<SettingsAccountFirimInfoView> {

    private var key: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    private static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
    
    static func instance(_ key: String) -> Self {
        let controller = instance()
        controller.key = key
        return controller
    }
}
