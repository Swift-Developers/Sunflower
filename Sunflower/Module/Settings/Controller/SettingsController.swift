//
//  SettingsController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences
import UserNotifications

class SettingsController: ViewController<SettingsView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.set(uploadRetry: Settings.isUploadRetry)
        container.set(uploadNotification: Settings.isUploadNotification)
    }
    
    @IBAction func appearanceAction(_ sender: NSButton) {
        switch sender.tag {
        case 0:     Appearance.current = .aqua
        case 1:     Appearance.current = .dark
        case 2:     Appearance.current = .auto
        default: break
        }
        container.set(appearance: Appearance.current)
    }
    
    @IBAction func statusBarAction(_ sender: NSPopUpButton) {
        
    }

    @IBAction func uploadRetryAction(_ sender: NSButton) {
        Settings.isUploadRetry = sender.state == .on
    }
    
    @IBAction func uploadNotificationAction(_ sender: NSButton) {
        if sender.state == .on {
            sender.isEnabled = false
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    sender.state = result ? .on : .off
                    Settings.isUploadNotification = result
                }
            }
            
        } else {
            Settings.isUploadNotification = false
        }
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsController: PreferencePane {
    
    var preferencePaneIdentifier: Preferences.PaneIdentifier { .general }
    
    var preferencePaneTitle: String { "通用" }
    
    var toolbarItemIcon: NSImage { NSImage(named: NSImage.preferencesGeneralName) ?? .init() }
}
