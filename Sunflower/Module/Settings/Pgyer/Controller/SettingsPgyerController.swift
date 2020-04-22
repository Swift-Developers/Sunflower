//
//  SettingsPgyerController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa

class SettingsPgyerController: ViewController<SettingsPgyerView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
