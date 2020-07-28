//
//  SettingsRobotFeishuCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/7/28.
//

import Cocoa

class SettingsRobotFeishuCreateController: ViewController<SettingsRobotFeishuCreateView> {

    var completion: ((Robot.Feishu) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        let temp = Robot.Feishu(key: container.key, name: container.name)
        var models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
        models.removeAll(where: { $0.key == container.key })
        models.append(temp)
        UserDefaults.RobotInfo.set(model: models, forKey: .feishu)
        
        dismiss(self)
        
        completion?(temp)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
