//
//  ReceivePopoverController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Cocoa

class ReceivePopoverController: ViewController<ReceivePopoverView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    static func instance() -> Self {
        return StoryBoard.receive.instance()
    }
}
