//
//  SettingsAccountView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa

class SettingsAccountView: NSView {

    @IBOutlet weak var listView: NSOutlineView!
    @IBOutlet weak var infoView: NSView!
    
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    /// 更新列表
    /// - Parameter handle: 处理
    func updatesList( handle: () -> Void) {
        listView.beginUpdates()
        handle()
        listView.endUpdates()
    }
    
    /// 刷新列表
    func reloadList() {
        listView.reloadData()
    }
    
    /// 展开列表
    func expandList() {
        listView.expandItem(nil, expandChildren: true)
    }
    
    /// 显示移除按钮
    func showRemoveButton() {
        removeButton.isHidden = false
    }
    /// 隐藏移除按钮
    func hideRemoveButton() {
        removeButton.isHidden = true
    }
}
