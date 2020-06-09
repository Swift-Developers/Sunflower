//
//  Pgyer.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Foundation

enum Pgyer {
    
    /// 文档 https://www.pgyer.com/doc/view/api#uploadApp
    struct Upload {
        let key: String             // Key
        let installType: Int = 2    // 应用安装方式，值为(2,3)。2：密码安装，3：邀请安装
        let password: String        // 安装密码
        let description: String     // 版本更新描述
        let file: URL
    }
}
