//
//  SettingsAccountView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa

class SettingsAccountView: NSView {

    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var infoView: NSView!
    
    @IBOutlet weak var createButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listView.register(NSNib(nibNamed: "SettingsAccountItem", bundle: nil), forItemWithIdentifier: .init("cell"))
        listView.register(SettingsAccountSectionHeader.self, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: .init("header"))
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
