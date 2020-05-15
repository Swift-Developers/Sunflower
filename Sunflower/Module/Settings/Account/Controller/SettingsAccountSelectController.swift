//
//  SettingsAccountSelectController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class SettingsAccountSelectController: ViewController<SettingsAccountSelectView> {

    private let list: [Account] = Account.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func continueAction(_ sender: NSButton) {
        let presenting = presentingViewController
        dismiss(self)
        let controller = SettingsAccountCreateController.instance(list[container.tableView.selectedRow])
        presenting?.presentAsSheet(controller)
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsAccountSelectController: NSTableViewDelegate {
    
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

extension SettingsAccountSelectController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
}

fileprivate extension Account {
    
    var name: String {
        switch self {
        case .pgyer:    return "蒲公英"
        case .firim:    return "fir.im"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .pgyer:    return #imageLiteral(resourceName: "platform_icon_pgyer")
        case .firim:    return #imageLiteral(resourceName: "platform_icon_firim")
        }
    }
}
