//
//  UploadSuccessController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa
import UserNotifications

class UploadSuccessController: ViewController<NSView> {

    @IBOutlet private weak var messageLabel: NSTextField!
    
    /// 提示消息
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    
    /// 安装包地址
    var url: URL?
    /// 应用名称
    var name: String = ""
    /// 更新记录
    var notes: String = ""
    /// 安装密码
    var password: String?
    /// 是否本地通知
    var local: Bool = false
    /// 是否机器人通知
    var robot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 本地通知
        localNotification()
        // 机器人通知
        robotNotification()
    }
    
    @IBAction func detailAction(_ sender: Any) {
        guard let url = url else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(self)
        
        let controller = ReceiveController.instance()
        view.window?.contentViewController = controller
    }
    
    static func instance() -> Self {
        return StoryBoard.upload.instance()
    }
}

extension UploadSuccessController {
    
    private func localNotification() {
        guard local else { return }
        let name = self.name
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
            defer { Settings.isUploadNotification = result }
            guard result else { return }
            
            DispatchQueue.main.async {
                let content = UNMutableNotificationContent()
                content.title = "上传完成"
                content.body = "\(name) 已上传至 "
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                let request = UNNotificationRequest(identifier: "", content: content, trigger: trigger)
                center.add(request) { (error) in }
            }
        }
    }
    
    private func robotNotification() {
        guard robot else { return }
        
        let installation = url?.absoluteString
        
        Upload.robots.forEach { (key, value) in
            guard let type = Robot(rawValue: key) else { return }
            
            let infos = type.infos(for: value)
            
            infos.forEach { (info) in
                switch info {
                case .wechat(let value):
                    var content = """
                    \(notes)
                    
                    """
                    if let value = url?.absoluteString {
                        content += """
                        
                        安装地址: \(value)
                        """
                    }
                    if let value = password {
                        content += """
                        
                        安装密码: \(value)
                        """
                    }
                    
                    API.wechat.load(
                        .sendText(key: value.key, content: content, at: []),
                        options: [.retry(.count(3))]
                    )
                    
                case .feishu(let value):
                    let title = "[iOS] \(name)"
                    var content = """
                    \(notes)
                    
                    """
                    if let value = password {
                        content += """
                        
                        安装密码: \(value)
                        """
                    }
                    
                    API.feishu.load(
                        .sendText(key: value.key, title: title, content: content, url: installation),
                        options: [.retry(.count(3))]
                    )
                }
            }
        }
    }
}
