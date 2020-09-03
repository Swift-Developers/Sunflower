//
//  Upload.swift
//  Sunflower
//
//  Created by Lee on 2020/9/2.
//

import AppKit

enum Upload {
    
    // [Type: [Key]] e.g. ["wechat": ["xxxxxxx", "xxxxxxx"]]
    static var robots: [String: [String]] {
        get { return UserDefaults.UploadInfo.model(forKey: .robots) ?? [:] }
        set { UserDefaults.UploadInfo.set(model: newValue, forKey: .robots) }
    }
    
    struct Notification {
        let local: Bool     // 本地
        let robot: Bool     // 机器人
    }
}

extension Upload {
    
    static func prepare(in parent: NSViewController, with completion: @escaping ((Notification) -> Void)) {
        let controller = UploadRobotController.instance()
        parent.presentAsSheet(controller)
        controller.skip = {
            completion(.init(local: Settings.isUploadNotification, robot: false))
        }
        controller.done = {
            completion(.init(local: Settings.isUploadNotification, robot: true))
        }
    }
}
