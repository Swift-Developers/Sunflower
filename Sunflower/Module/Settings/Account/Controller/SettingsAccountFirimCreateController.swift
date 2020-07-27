//
//  SettingsAccountFirimCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/8.
//

import Cocoa

class SettingsAccountFirimCreateController: ViewController<SettingsAccountFirimCreateView> {

    var completion: ((Account.Firim) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        let temp = Account.Firim(key: container.key, name: container.name)
        var models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
        models.removeAll(where: { $0.key == container.key })
        models.append(temp)
        UserDefaults.AccountInfo.set(model: models, forKey: .firim)
        
        dismiss(self)
        
        completion?(temp)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
