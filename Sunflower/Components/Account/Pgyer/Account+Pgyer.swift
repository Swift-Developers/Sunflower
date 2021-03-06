//
//  Account+Pgyer.swift
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

import Foundation

extension Account {
    
    struct Pgyer: Codable {
        let key: String             // API Key
        var name: String            // 别名
        var password: String        // 安装密码
    }
}
