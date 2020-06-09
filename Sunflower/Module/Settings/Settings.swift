//
//  Settings.swift
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

import Foundation
import Preferences

enum Settings: String, CaseIterable {
    case general        // 通用
    case account        // 账号
    case robot          // 机器人
}

extension Preferences.PaneIdentifier {
    static let general = Preferences.PaneIdentifier("general")
    static let account = Preferences.PaneIdentifier("account")
    static let robot = Preferences.PaneIdentifier("robot")
}

