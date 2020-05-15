//
//  SettingsAccountCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class SettingsAccountCreateController: ViewController<SettingsAccountCreateView> {

    private var type: Account = .pgyer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        switch type {
        case .pgyer:
            var models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
            models.removeAll(where: { $0.key == container.key })
            models.append(.init(key: container.key, name: container.name))
            UserDefaults.AccountInfo.set(model: models, forKey: .pgyer)
            
        case .firim:
            var models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
            models.removeAll(where: { $0.key == container.key })
            models.append(.init(key: container.key, name: container.name))
            UserDefaults.AccountInfo.set(model: models, forKey: .firim)
        }
        dismiss(self)
    }
    
    private static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
    
    static func instance(_ type: Account) -> Self {
        let controller = instance()
        controller.type = type
        return controller
    }
}
