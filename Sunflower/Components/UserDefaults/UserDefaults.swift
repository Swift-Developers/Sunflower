//
//  UserDefaults.swift
//  Sunflower
//
//  Created by Lee on 2020/4/24.
//

import Foundation

extension UserDefaults {
    
    // 设置信息
    enum SettingsInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case appearance
            case statusbar
            case upload
        }
    }
    
    // 账号信息
    enum AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case pgyer
            case firim
        }
    }
    
    // 机器人信息
    enum RobotInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case wechat
            case feishu
        }
    }
}
