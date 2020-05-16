//
//  SettingsRobotCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa

class SettingsRobotCreateController: ViewController<SettingsRobotCreateView> {

    private var type: Robot = .wechat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        switch type {
        case .wechat:
            var models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
            models.removeAll(where: { $0.key == container.key })
            models.append(.init(key: container.key, name: container.name))
            UserDefaults.RobotInfo.set(model: models, forKey: .wechat)
            
        case .feishu:
            var models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
            models.removeAll(where: { $0.key == container.key })
            models.append(.init(key: container.key, name: container.name))
            UserDefaults.RobotInfo.set(model: models, forKey: .feishu)
        }
        dismiss(self)
    }
    
    private static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
    
    static func instance(_ type: Robot) -> Self {
        let controller = instance()
        controller.type = type
        return controller
    }
}
