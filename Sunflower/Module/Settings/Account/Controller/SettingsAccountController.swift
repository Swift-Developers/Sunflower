//
//  SettingsAccountController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences
import AttributedString

class SettingsAccountController: ViewController<SettingsAccountView> {

    typealias Item = SettingsAccountModel.Item
    typealias Child = SettingsAccountModel.Item.Child
    
    private let model = SettingsAccountModel()
    private var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadData()
    }
    
    private func setup() {
        model.changed = { [weak self] new in
            guard let self = self else { return }
            self.container.updatesList {
                self.items = new
                self.container.reloadList()
                self.container.expandList()
                self.container.hideRemoveButton()
            }
        }
    }
    
    /// 加载数据
    private func loadData() {
        container.updatesList {
            items = model.datas
            container.reloadList()
            container.expandList()
            container.hideRemoveButton()
        }
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        /// 写入缓存
        do {
            var models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
            models.append(.init(key: "0ce394fa6a416873a32fc62e" + String.random(ofLength: 8), alias: "18611401994@163.com"))
            UserDefaults.AccountInfo.set(model: models, forKey: .pgyer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            do {
                var models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
                models.append(.init(key: "1ce394fa6a416873a32fc62e" + String.random(ofLength: 8), alias: "18611401994@qq.com"))
                UserDefaults.AccountInfo.set(model: models, forKey: .firim)
            }
        }
    }
    
    @IBAction func removeAction(_ sender: NSButton) {
        guard let window = sender.window else {
            return
        }
        
        func remove() {
            guard
                let listView = container.listView,
                let selected = listView.item(atRow: listView.selectedRow),
                let parent = listView.parent(forItem: selected),
                let child = selected as? Item.Child,
                let item = parent as? Item else {
                return
            }
            print(item)
            print(child)
            self.model.remove(type: item.type, with: child)
        }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "删除")
        alert.addButton(withTitle: "取消")
        alert.messageText = "是否删除该账号?"
        alert.beginSheetModal(for: window) { (response) in
            guard response == .alertFirstButtonReturn else { return }
            remove()
        }
    }
    
    static func instance() -> Self {
        return StoryBoard.settings.instance()
    }
}

extension SettingsAccountController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 40
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let item = item as? Item {
            let cell = outlineView.makeView(
                withIdentifier: .init(rawValue: "header"),
                owner: self
            ) as? NSTableCellView
            cell?.textField?.stringValue = item.type.name
            cell?.imageView?.image = item.type.icon
            return cell
        }
        if let item = item as? Item.Child {
            let cell = outlineView.makeView(
                withIdentifier: .init(rawValue: "child"),
                owner: self
            ) as? NSTableCellView
            cell?.textField?.attributed.string = """
            \(String(item.name.prefix(16)) + "..", .font(.systemFont(ofSize: 13)))
            \(String(item.key.prefix(18)) + "..", .font(.systemFont(ofSize: 11)), .color(.tertiaryLabelColor))
            """
            
            return cell
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return item is Item.Child
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard
            let listView = notification.object as? NSOutlineView,
            let selected = listView.item(atRow: listView.selectedRow),
            let parent = listView.parent(forItem: selected),
            let child = selected as? Item.Child,
            let item = parent as? Item else {
            return
        }
        print(item)
        print(child)
        container.showRemoveButton()
    }
}

extension SettingsAccountController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Item {
            return item.childs.count
        }
        return items.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Item {
            return item.childs[index]
        }
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return outlineView.parent(forItem: item) == nil
    }
}

extension SettingsAccountController: PreferencePane {
        
    var preferencePaneIdentifier: Identifier { .account }
        
    var preferencePaneTitle: String { "账号" }
    
    var toolbarItemIcon: NSImage { NSImage.init(named: NSImage.userAccountsName) ?? .init() }
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
