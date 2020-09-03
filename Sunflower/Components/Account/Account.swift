//
//  Account.swift
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

import Cocoa
import AttributedString

enum Account: String, CaseIterable {
    case pgyer
    case firim
}

extension Account {
    
    enum Info {
        case pgyer(Account.Pgyer)
        case firim(Account.Firim)
    }
    
    static func select(in parent: NSViewController, with completion: @escaping ((Info) -> Void)) {
        
        var accounts: [Info] = []
        do {
            let models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
            accounts += models.map { .pgyer($0) }
        }
        do {
            let models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
            accounts += models.map { .firim($0) }
        }
        
        switch accounts.count {
        case 0:
            // 无账号
            let controller = SinglePickerController.instance(
                Account.allCases.map({ .init(icon: $0.icon, name: .init(string: $0.name)) })
            )
            controller.completion = { index in
                switch Account.allCases[index] {
                case .pgyer:
                    let controller = SettingsAccountPgyerCreateController.instance()
                    controller.completion = { value in
                        completion(.pgyer(value))
                    }
                    parent.presentAsSheet(controller)
                    
                case .firim:
                    let controller = SettingsAccountFirimCreateController.instance()
                    controller.completion = { value in
                        completion(.firim(value))
                    }
                    parent.presentAsSheet(controller)
                }
            }
            parent.presentAsSheet(controller)
            
        case 1:
            // 一个账号
            switch accounts[0] {
            case .pgyer(let value):
                completion(.pgyer(value))
                
            case .firim(let value):
                completion(.firim(value))
            }
            
        default:
            // 多账号 单选
            let controller = SinglePickerController.instance(
                accounts.map { .init(icon: $0.icon, name: $0.name) }
            )
            controller.title = "选择账号"
            controller.completion = { index in
                switch accounts[index] {
                case .pgyer(let value):
                    completion(.pgyer(value))
                    
                case .firim(let value):
                    completion(.firim(value))
                }
            }
            parent.presentAsSheet(controller)
        }
    }
}

fileprivate extension Account.Info {
    
    var icon: NSImage {
        switch self {
        case .pgyer: return Account.pgyer.icon
        case .firim: return Account.firim.icon
        }
    }
    
    var name: NSAttributedString {
        let attributes: [AttributedString.Attribute] = [.font(.systemFont(ofSize: 12)), .foreground(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]
        switch self {
        case .pgyer(let value): return (value.name + AttributedString("\n\(value.key)", with: attributes)).value
        case .firim(let value): return (value.name + AttributedString("\n\(value.key)", with: attributes)).value
        }
    }
}

extension Account {
    
    var name: String {
        switch self {
        case .pgyer:    return "蒲公英"
        case .firim:    return "fir.im"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .pgyer:    return #imageLiteral(resourceName: "platform_icon_pgyer")
        case .firim:    return #imageLiteral(resourceName: "platform_icon_firim")
        }
    }
}
