//
//  Robot+Feishu.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Foundation

extension Robot {
    
    struct Feishu: Codable {
        let key: String             // API Key
        var name: String            // 别名
    }
}
