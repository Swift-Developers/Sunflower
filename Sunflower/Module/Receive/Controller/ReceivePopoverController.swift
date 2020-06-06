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
        
        setup()
    }
    
    private func setup() {
        container.dragView.delegate = self
    }
    
    static func instance() -> Self {
        return StoryBoard.receive.instance()
    }
}

extension ReceivePopoverController {
    
    private func handle(file url: URL) {
        Analysis.handle(file: url) { (result) in
            
        }
    }
}

extension ReceivePopoverController: ReceiveDragViewDelegate {
    
    func draggingFileAccept(file url: URL) {
        handle(file: url)
        AppDelegate.shared.popover.close()
    }
}
