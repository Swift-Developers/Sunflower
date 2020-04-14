//
//  AppDelegate.swift
//  BetaPublisher
//
//  Created by Lee on 2020/4/13.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    let popover = NSPopover()
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
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
        for window in sender.windows where !flag {
            window.makeKeyAndOrderFront(self)
        }
        return !flag
    }
}

extension AppDelegate {
    
    private func setup() {
        statusBar.button?.image = #imageLiteral(resourceName: "status_icon")
        statusBar.button?.action = #selector(statusAction)
        popover.contentViewController = ReceivePopoverController.instance()
    }
    
    @objc
    private func statusAction(_ sender: NSStatusBarButton) {
        if popover.isShown {
            popover.close()
            
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        }
    }
}

