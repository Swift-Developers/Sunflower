//
//  UploadRobotItem.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa
import AttributedString

class UploadRobotItem: NSCollectionViewItem {

    @IBOutlet weak var check: NSButton!
    @IBOutlet weak var label: NSTextField!
    
    var swicth: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var isSelected: Bool {
        didSet {
            check.state = isSelected ? .on : .off
        }
    }
    
    @IBAction func checkAction(_ sender: NSButton) {
        swicth?(sender.state == .on)
    }
}

extension UploadRobotItem {
    
    /// 设置
    /// - Parameters:
    ///   - key: key
    ///   - name: 名称
    func set(_ key: String, with name: String) {
        label.attributed.string = """
        \(format(name), .font(.systemFont(ofSize: 16))) - \(format(key), .font(.systemFont(ofSize: 12)), .foreground(.tertiaryLabelColor))
        """
    }
    
    private func format(_ string: String) -> String {
        string.count > 40 ? String(string.prefix(38)) + ".." : string
    }
}
