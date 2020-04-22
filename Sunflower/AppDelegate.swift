//
//  AppDelegate.swift
//  BetaPublisher
//
//  Created by Lee on 2020/4/13.
//

import Cocoa
import Preferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static var shared: AppDelegate {
        return NSApp.delegate as! AppDelegate
    }
    
    var window: NSWindow?
    
    let popover = NSPopover()
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private lazy var eventMonitor = EventMonitor.init([.leftMouseUp, .rightMouseUp]) { (event) in
        guard self.popover.isShown else { return }
        
        self.popover.close()
    }
    private var appearanceObservation: NSKeyValueObservation?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setup()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    /// 设置关闭窗口之后点击Dock中的图标可以再次打开窗口
    /// - Parameters:
    ///   - sender: 当前应用
    ///   - flag: 是否有显示的窗口
    /// - Returns: 是否重新打开
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        for window in sender.windows where !flag && window == self.window {
            window.makeKeyAndOrderFront(self)
        }
        return !flag
    }
}

extension AppDelegate {
    private static var o: Any?
    private func setup() {
        window = NSApplication.shared.mainWindow
        statusBar.button?.image = #imageLiteral(resourceName: "status_icon")
        statusBar.button?.action = #selector(statusAction)
        popover.contentViewController = ReceivePopoverController.instance()
        // 添加外观监听 同步popover样式
        appearanceObservation = NSApp.observe(\.appearance) { (observer, change) in
            self.popover.appearance = observer.appearance
        }
    }
    
    @objc
    private func statusAction(_ sender: NSStatusBarButton) {
        if popover.isShown {
            popover.close()
            eventMonitor.stop()
            
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
            eventMonitor.start()
        }
    }

    @IBAction
    private func preferencesMenuItemAction(_ sender: NSMenuItem) {
        let preferences = PreferencesWindowController(
            preferencePanes: [
                SettingsController.instance(),
                SettingsAccountController.instance(),
                SettingsRobotController.instance()
            ],
            style: .toolbarItems,
            animated: true,
            hidesToolbarForSingleItem: true
        )
        preferences.window?.titlebarAppearsTransparent = true
        preferences.show()
    }
}
