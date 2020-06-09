//
//  SettingsAccountFirimInfoController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import Cocoa

class SettingsAccountFirimInfoController: ViewController<SettingsAccountFirimInfoView> {

    private var key: String = ""
    
    private var model: Account.Firim {
        get {
            guard let models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) else {
                return .init(key: key, name: "")
            }
            return models.first(where: { $0.key == key }) ?? .init(key: key, name: "")
        }
        set {
            guard
                var models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim),
                let index = models.firstIndex(where: { $0.key == key }) else {
                return
            }
            models[index] = newValue
            UserDefaults.AccountInfo.set(model: models, forKey: .firim)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        container.set(key: model.key, name: model.name)
    }
    
    @IBAction func nameAction(_ sender: NSTextField) {
        guard !sender.stringValue.isEmpty else { return }
        sender.placeholderString = sender.stringValue
        model.name = sender.stringValue
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
