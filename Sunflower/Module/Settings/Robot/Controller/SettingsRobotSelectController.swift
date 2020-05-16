//
//  SettingsRobotSelectController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/16.
//

import Cocoa

class SettingsRobotSelectController: ViewController<SettingsRobotSelectView> {

    private let list: [Robot] = Robot.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func continueAction(_ sender: NSButton) {
        let presenting = presentingViewController
        dismiss(self)
        let controller = SettingsRobotCreateController.instance(list[container.tableView.selectedRow])
        presenting?.presentAsSheet(controller)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsRobotSelectController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: .init("cell"), owner: self) as? NSTableCellView
        cell?.imageView?.image = list[row].icon
        cell?.textField?.stringValue = list[row].name
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40.0
    }
}

extension SettingsRobotSelectController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
}

fileprivate extension Robot {
    
    var name: String {
        switch self {
        case .wechat:    return "企业微信"
        case .feishu:    return "飞书"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .wechat:    return #imageLiteral(resourceName: "platform_icon_wechat")
        case .feishu:    return #imageLiteral(resourceName: "platform_icon_feishu")
        }
    }
}
