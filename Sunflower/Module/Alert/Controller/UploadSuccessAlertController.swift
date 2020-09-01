//
//  UploadSuccessAlertController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/12.
//

import Cocoa
import UserNotifications

class UploadSuccessAlertController: ViewController<NSView> {

    @IBOutlet private weak var messageLabel: NSTextField!
    
    var message: String {
        get { messageLabel.stringValue }
        set { messageLabel.stringValue = newValue }
    }
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 发送本地通知
        if Settings.isUploadNotification {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
                guard result else { return }
                
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "提示"
                    content.body = "已上传完成"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                    let request = UNNotificationRequest(identifier: "", content: content, trigger: trigger)
                    center.add(request) { (error) in }
                }
            }
        }
        
        
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
        NSApp.mainWindow?.contentViewController = controller
    }
    
    static func instance() -> Self {
        return StoryBoard.alert.instance()
    }
}
