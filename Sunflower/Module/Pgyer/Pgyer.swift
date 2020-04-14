//
//  Pgyer.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Foundation

enum Pgyer {
    
    static var apiKey = "b7b9e51d9589c2e9c6002db2214111ee"
    
    static var userKey = "e8db90f09703e5a141046fe115d3dfe0"
    
    static var password = "123456"
    
    /// ipa状态
    enum State {
        /// 已存在文件
        case existed
        /// 上传中
        case uploading
        /// 准备
        case ready
    }
}

extension Pgyer {
    
    struct Upload {
        let installType: Int = 2    //应用安装方式，值为(2,3)。2：密码安装，3：邀请安装
        let password: String = Pgyer.password   //
        let description: String     //版本更新描述，请传空字符串，或不传。
        let file: URL
        
        /// 文档 https://www.pgyer.com/doc/view/api#uploadApp
    }
}
