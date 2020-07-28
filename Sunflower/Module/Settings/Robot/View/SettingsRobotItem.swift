//
//  SettingsRobotItem.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa
import AttributedString

class SettingsRobotItem: NSCollectionViewItem {

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var isSelected: Bool {
        didSet {
            view.borderWidth = isSelected ? 2 : 0
            view.borderColor = .blue
        }
    }
}

extension SettingsRobotItem {
    
    /// 设置
    /// - Parameters:
    ///   - key: key
    ///   - name: 名称
    func set(_ key: String, with name: String) {
        label.attributed.string = """
        \(format(name), .font(.systemFont(ofSize: 13)))
        \(format(key), .font(.systemFont(ofSize: 11)), .foreground(.tertiaryLabelColor))
        """
    }
    
    private func format(_ string: String) -> String {
        string.count > 18 ? String(string.prefix(16)) + ".." : string
    }
}
