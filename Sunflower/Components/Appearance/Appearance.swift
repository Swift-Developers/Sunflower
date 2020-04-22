//
//  Appearance.swift
//  Sunflower
//
//  Created by Lee on 2020/4/22.
//

import AppKit

enum Appearance {
    case auto       // 自动
    case aqua       // 浅色
    case dark       // 深色
}

extension Appearance {
    
    var appearance: NSAppearance? {
        switch self {
        case .aqua:     return NSAppearance(named: .aqua)
        case .dark:     return NSAppearance(named: .darkAqua)
        default:        return nil
        }
    }
    
    static var current: Appearance {
        get {
            let name = NSApp.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua])
            switch name {
            case .aqua? where NSApp.appearance == nil:
                return .auto
                
            case .aqua? where NSApp.appearance != nil:
                return .aqua
                
            case .darkAqua? where NSApp.appearance == nil:
                return .auto
                
            case .darkAqua? where NSApp.appearance != nil:
                return .dark
                
            default:
                return .auto
            }
        }
        set {
            NSApp.appearance = newValue.appearance
        }
    }
}
