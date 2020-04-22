//
//  SettingsView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa

class SettingsView: NSView {

    /// 外观
    @IBOutlet weak var appearanceAquaButton: NSButton!
    @IBOutlet weak var appearanceDarkButton: NSButton!
    @IBOutlet weak var appearanceAutoButton: NSButton!
    /// 状态栏
    @IBOutlet weak var statusBarButton: NSPopUpButton!
    /// 上传
    @IBOutlet weak var uploadRetryButton: NSButton!
    @IBOutlet weak var uploadNotificationButton: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    func set(appearance style: Appearance) {
        switch style {
        case .aqua:
            appearanceAquaButton.state = .on
            appearanceDarkButton.state = .off
            appearanceAutoButton.state = .off
            
        case .dark:
            appearanceAquaButton.state = .off
            appearanceDarkButton.state = .on
            appearanceAutoButton.state = .off
            
        case .auto:
            appearanceAquaButton.state = .off
            appearanceDarkButton.state = .off
            appearanceAutoButton.state = .on
        }
    }
}
