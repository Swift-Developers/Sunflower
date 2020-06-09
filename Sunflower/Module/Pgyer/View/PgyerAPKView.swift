//
//  PgyerAPKView.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class PgyerAPKView: NSView {

    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet var descriptionTextView: NSTextView!
    
    /// 更新描述
    var notes: String {
        get { descriptionTextView.string }
        set { descriptionTextView.string = newValue }
    }
    
}
