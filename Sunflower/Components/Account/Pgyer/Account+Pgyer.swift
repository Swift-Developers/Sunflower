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
        var alias: String?          // 别名
    }
}
