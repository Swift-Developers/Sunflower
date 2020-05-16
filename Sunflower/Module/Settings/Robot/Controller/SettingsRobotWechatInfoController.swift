//
//  SettingsRobotWechatInfoController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa

class SettingsRobotWechatInfoController: ViewController<SettingsRobotWechatInfoView> {

    private var key: String = ""
    
    private var model: Robot.Wechat {
        get {
            guard let models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) else {
                return .init(key: key, name: "")
            }
            return models.first(where: { $0.key == key }) ?? .init(key: key, name: "")
        }
        set {
            guard
                var models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat),
                let index = models.firstIndex(where: { $0.key == key }) else {
                return
            }
            models[index] = newValue
            UserDefaults.RobotInfo.set(model: models, forKey: .wechat)
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
