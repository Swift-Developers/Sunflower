//
//  ReceivePopoverView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Cocoa

class ReceivePopoverView: NSView {
  
    @IBOutlet weak var dragView: ReceiveDragView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置接受类型
        dragView.types = Receive.types
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
}
