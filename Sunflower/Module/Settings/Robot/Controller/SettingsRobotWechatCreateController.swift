//
//  SettingsRobotWechatCreateController.swift
//  Sunflower
//
//  Created by Lee on 2020/7/28.
//

import Cocoa

class SettingsRobotWechatCreateController: ViewController<SettingsRobotWechatCreateView> {

    var completion: ((Robot.Wechat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        let temp = Robot.Wechat(key: container.key, name: container.name)
        var models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
        models.removeAll(where: { $0.key == container.key })
        models.append(temp)
        UserDefaults.RobotInfo.set(model: models, forKey: .wechat)
        
        dismiss(self)
        
        completion?(temp)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}
