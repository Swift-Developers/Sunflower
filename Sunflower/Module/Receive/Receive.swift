//
//  Receive.swift
//  Sunflower
//
//  Created by Lee on 2020/4/14.
//

import Foundation

enum Receive {
    /// 接受类型
    static let types: [String] = Analysis.allCases.map(by: \.rawValue)
}
