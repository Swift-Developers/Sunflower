//
//  Robot.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa
import AttributedString

enum Robot: String, CaseIterable {
    case wechat
    case feishu
}

extension Robot {
    
    enum Info {
        case wechat(Robot.Wechat)
        case feishu(Robot.Feishu)
    }
    
    func infos(for keys: [String]) -> [Info] {
        switch self {
        case .wechat:
            let models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
            return models.filter({ keys.contains($0.key) }).map({ .wechat($0) })
            
        case .feishu:
            let models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
            return models.filter({ keys.contains($0.key) }).map({ .feishu($0) })
        }
    }
    
    static func select(in parent: NSViewController, with completion: @escaping ((Info) -> Void)) {
        
        var robots: [Info] = []
        do {
            let models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
            robots += models.map { .wechat($0) }
        }
        do {
            let models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
            robots += models.map { .feishu($0) }
        }
        
        switch robots.count {
        case 0:
            // 无账号
            let controller = SinglePickerController.instance(
                Robot.allCases.map({ .init(icon: $0.icon, name: .init(string: $0.name)) })
            )
            controller.completion = { index in
                switch Robot.allCases[index] {
                case .wechat:
                    let controller = SettingsRobotWechatCreateController.instance()
                    controller.completion = { value in
                        completion(.wechat(value))
                    }
                    parent.presentAsSheet(controller)
                    
                case .feishu:
                    let controller = SettingsRobotFeishuCreateController.instance()
                    controller.completion = { value in
                        completion(.feishu(value))
                    }
                    parent.presentAsSheet(controller)
                }
            }
            parent.presentAsSheet(controller)
            
        case 1:
            // 一个账号
            switch robots[0] {
            case .wechat(let value):
                completion(.wechat(value))
                
            case .feishu(let value):
                completion(.feishu(value))
            }
            
        default:
            // 多账号 单选
            let controller = SinglePickerController.instance(
                robots.map { .init(icon: $0.icon, name: $0.name) }
            )
            controller.title = "选择账号"
            controller.completion = { index in
                switch robots[index] {
                case .wechat(let value):
                    completion(.wechat(value))
                    
                case .feishu(let value):
                    completion(.feishu(value))
                }
            }
            parent.presentAsSheet(controller)
        }
    }
}

fileprivate extension Robot.Info {
    
    var icon: NSImage {
        switch self {
        case .wechat: return Robot.wechat.icon
        case .feishu: return Robot.feishu.icon
        }
    }
    
    var name: NSAttributedString {
        let attributes: [AttributedString.Attribute] = [.font(.systemFont(ofSize: 12)), .foreground(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]
        switch self {
        case .wechat(let value): return (value.name + AttributedString("\n\(value.key)", with: attributes)).value
        case .feishu(let value): return (value.name + AttributedString("\n\(value.key)", with: attributes)).value
        }
    }
}

extension Robot {
    
    var name: String {
        switch self {
        case .wechat:    return "企业微信"
        case .feishu:    return "飞书"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .wechat:    return #imageLiteral(resourceName: "platform_icon_wechat")
        case .feishu:    return #imageLiteral(resourceName: "platform_icon_feishu")
        }
    }
}
