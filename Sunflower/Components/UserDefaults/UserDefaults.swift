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
        enum Keys: String, UserDefaultsSettableKeys {
            case appearance
            case statusbar
            case uploadRetry
            case uploadNotification
        }
    }
    
    // 账号信息
    enum AccountInfo: UserDefaultsSettable {
        enum Keys: String, UserDefaultsSettableKeys {
            case pgyer
            case firim
        }
    }
    
    // 机器人信息
    enum RobotInfo: UserDefaultsSettable {
        enum Keys: String, UserDefaultsSettableKeys {
            case wechat
            case feishu
        }
    }
    
    // 上传配置信息
    enum UploadInfo: UserDefaultsSettable {
        enum Keys: String, UserDefaultsSettableKeys {
            case robots
        }
    }
}
