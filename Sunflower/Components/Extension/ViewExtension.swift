//
//  ViewExtension.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import AppKit

extension NSView {
    
    @IBInspectable
    var customCornerRadius: CGFloat {
        get {
            return layer?.cornerRadius ?? 0
        }
        set {
            wantsLayer = true
            layer?.masksToBounds = true
            layer?.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}
