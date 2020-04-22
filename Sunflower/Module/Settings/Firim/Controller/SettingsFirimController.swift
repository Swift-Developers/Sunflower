//
//  SettingsFirimController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa

class SettingsFirimController: ViewController<SettingsFirimView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
