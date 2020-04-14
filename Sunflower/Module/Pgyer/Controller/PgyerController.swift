//
//  PgyerController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Cocoa

class PgyerController: ViewController<PgyerView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instance() -> Self {
        return StoryBoard.pgyer.instance()
    }
}
