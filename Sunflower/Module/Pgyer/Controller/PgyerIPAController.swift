//
//  PgyerIPAController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/16.
//

import Cocoa

class PgyerIPAController: ViewController<PgyerIPAView> {

    typealias Info = Analysis.IPA
    
    private var info: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        title = info?.name
    }
    
    static func instance(_ info: Info) -> Self {
        let controller = instance()
        controller.info = info
        return controller
    }
    
    private static func instance() -> Self {
        return StoryBoard.pgyer.instance()
    }
}
