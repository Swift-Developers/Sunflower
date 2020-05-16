//
//  SettingsRobotFeishuInfoController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa

class SettingsRobotFeishuInfoController: ViewController<SettingsRobotFeishuInfoView> {

    private var key: String = ""
    
    private var model: Robot.Feishu {
        get {
            guard let models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) else {
                return .init(key: key, name: "")
            }
            return models.first(where: { $0.key == key }) ?? .init(key: key, name: "")
        }
        set {
            guard
                var models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu),
                let index = models.firstIndex(where: { $0.key == key }) else {
                return
            }
            models[index] = newValue
            UserDefaults.RobotInfo.set(model: models, forKey: .feishu)
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
