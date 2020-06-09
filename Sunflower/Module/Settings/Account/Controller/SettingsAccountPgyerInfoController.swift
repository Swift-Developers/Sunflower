//
//  SettingsAccountPgyerInfoController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import Cocoa

class SettingsAccountPgyerInfoController: ViewController<SettingsAccountPgyerInfoView> {

    private var key: String = ""
    
    private var model: Account.Pgyer {
        get {
            guard let models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) else {
                return .init(key: key, name: "", password: "")
            }
            return models.first(where: { $0.key == key }) ?? .init(key: key, name: "", password: "")
        }
        set {
            guard
                var models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer),
                let index = models.firstIndex(where: { $0.key == key }) else {
                return
            }
            models[index] = newValue
            UserDefaults.AccountInfo.set(model: models, forKey: .pgyer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        container.set(key: model.key, name: model.name, password: model.password)
    }
    
    @IBAction func nameAction(_ sender: NSTextField) {
        guard !sender.stringValue.isEmpty else { return }
        sender.placeholderString = sender.stringValue
        model.name = sender.stringValue
    }
    
    @IBAction func passwordAction(_ sender: NSTextField) {
        guard !sender.stringValue.isEmpty else { return }
        sender.placeholderString = sender.stringValue
        model.password = sender.stringValue
    }
    
    private static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
    
    static func instance(_ key: String) -> Self {
        let controller = instance()
        controller.key = key
        return controller
    }
}
