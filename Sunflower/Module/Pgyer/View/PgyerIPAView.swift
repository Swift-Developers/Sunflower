//
//  PgyerIPAView.swift
//  Sunflower
//
//  Created by Lee on 2020/4/16.
//

import Cocoa

class PgyerIPAView: NSView {

    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var idLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var creationLabel: NSTextField!
    @IBOutlet weak var sizeLabel: NSTextField!
    @IBOutlet weak var embeddedButton: NSButton!
    
    @IBOutlet var notesTextView: NSTextView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
}

extension PgyerIPAView {
    
    /// 设置应用信息
    /// - Parameter info: 信息
    func set(_ info: Analysis.IPA) {
        iconImageView.image = info.icon
        idLabel.stringValue = info.bundleId
        nameLabel.stringValue = info.name + " (\(info.bundleName))"
        versionLabel.stringValue = info.version + "(\(info.bundleVersion))"
        creationLabel.stringValue = info.creationDate?.string(withFormat: "yyyy年MM月dd日 HH:mm") ?? "未知"
        embeddedButton.stringValue = info.embedded?.name ?? "未知"
    }
    
    /// 设置文件地址
    /// - Parameter file: 地址
    func set(_ file: URL?) {
        guard let url = file, FileManager.default.fileExists(atPath: url.path) else {
            sizeLabel.stringValue = "未知"
            return
        }
        
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        let size = attributes?[.size] as? UInt64
        sizeLabel.stringValue = "\(size ?? 0)"
    }
    
    /// 设置更新记录
    /// - Parameter notes: 记录
    func set(_ notes: String) {
        notesTextView.string = notes
    }
}
