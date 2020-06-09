//
//  SettingsAccountPgyerCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class SettingsAccountPgyerCreateController: ViewController<SettingsAccountPgyerCreateView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        var models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
        models.removeAll(where: { $0.key == container.key })
        models.append(.init(key: container.key, name: container.name, password: container.password))
        UserDefaults.AccountInfo.set(model: models, forKey: .pgyer)
        
        dismiss(self)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
