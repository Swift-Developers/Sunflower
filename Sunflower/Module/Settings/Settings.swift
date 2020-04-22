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

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let account = Identifier("account")
    static let robot = Identifier("robot")
}

