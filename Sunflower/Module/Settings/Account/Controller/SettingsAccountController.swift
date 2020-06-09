//
//  SettingsAccountController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences
import DifferenceKit

class SettingsAccountController: ViewController<SettingsAccountView> {

    typealias Section = SettingsAccountModel.Section
    
    private let model = SettingsAccountModel()
    private var sections: [ArraySection<Account, Section.Item>] = []
    private var selected: IndexPath? {
        didSet { updateInfo() }
    }
    private weak var currentInfoController: NSViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadData()
    }
    
    private func setup() {
        model.changed = { [weak self] new in
            guard let self = self else { return }
            // 刷新列表
            let source = self.sections
            let target = new.map {
                ArraySection(model: $0.type, elements: $0.items)
            }
            let changeset = StagedChangeset(source: source, target: target)
            self.container.listView.reload(using: changeset) { (data) in
                self.sections = data
            }
            
            // 同步选中项
            if let indexPath = self.selected {
                let type = source[indexPath.section].model
                let item = source[indexPath.section].elements[indexPath.item]
                if
                    let sectionIndex = target.firstIndex(where: { $0.model == type }),
                    let itemIndex = target[sectionIndex].elements.firstIndex(where: { $0.key == item.key }) {
                    let selected = IndexPath(item: itemIndex, section: sectionIndex)
                    self.selected = selected
                    self.container.listView.selectItems(at: Set([selected]), scrollPosition: .init())
                    
                } else {
                    self.selected = nil
                }
            }
        }
    }
    
    /// 加载数据
    private func loadData() {
        sections = model.datas.map {
            ArraySection(model: $0.type, elements: $0.items)
        }
        container.listView.reloadData()
        container.hideRemoveButton()
    }
    
    @IBAction func createAction(_ sender: NSButton) {
        let controller = SinglePickerController.instance(
            Account.allCases.map({ .init(icon: $0.icon, name: .init(string: $0.name)) })
        )
        controller.completion = { [weak self] index in
            switch Account.allCases[index] {
            case .pgyer:
                let controller = SettingsAccountPgyerCreateController.instance()
                self?.presentAsSheet(controller)
                
            case .firim:
                let controller = SettingsAccountPgyerCreateController.instance()
                self?.presentAsSheet(controller)
            }
        }
        presentAsSheet(controller)
    }
    
    @IBAction func removeAction(_ sender: NSButton) {
        guard let window = sender.window else {
            return
        }
        
        func remove() {
            guard let indexPath = selected else {
                return
            }
            
            let section = sections[indexPath.section]
            let item = section.elements[indexPath.item]
            
            // 移除数据
            model.remove(type: section.model, with: item)
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

extension SettingsAccountController {
    
    private func showInfo(type: Account, with key: String) {
        emptyInfo()
        
        switch type {
        case .pgyer:
            let controller = SettingsAccountPgyerInfoController.instance(key)
            add(child: controller, to: container.infoView)
            currentInfoController = controller
            
        case .firim:
            let controller = SettingsAccountFirimInfoController.instance(key)
            add(child: controller, to: container.infoView)
            currentInfoController = controller
        }
    }
    
    private func emptyInfo() {
        currentInfoController?.removeFromParentController()
    }
    
    private func updateInfo() {
        if let indexPath = selected {
            container.showRemoveButton()
            // 更新信息
            let section = sections[indexPath.section]
            let item = section.elements[indexPath.item]
            showInfo(type: section.model, with: item.key)
            
        } else {
            container.hideRemoveButton()
            emptyInfo()
        }
    }
}

extension SettingsAccountController: NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return .init(width: 180, height: 40)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SettingsAccountController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .init("cell"), for: indexPath) as! SettingsAccountItem
        let item = sections[indexPath.section].elements[indexPath.item]
        cell.set(item.key, with: item.name)
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case NSCollectionView.elementKindSectionHeader:
            let header = collectionView.makeSupplementaryView(
                ofKind: kind,
                withIdentifier: .init("header"),
                for: indexPath
            ) as! SettingsAccountSectionHeader
            let model = sections[indexPath.section].model
            header.set(model.icon, with: model.name)
            return header
            
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        selected = indexPaths.first
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard selected == indexPaths.first else {
            return
        }
        selected = nil
    }
}

extension SettingsAccountController: PreferencePane {
        
    var preferencePaneIdentifier: Preferences.PaneIdentifier { .account }
        
    var preferencePaneTitle: String { "账号" }
    
    var toolbarItemIcon: NSImage { NSImage(named: NSImage.userAccountsName) ?? .init() }
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

extension SettingsAccountModel.Section.Item: Differentiable {
    
    var differenceIdentifier: String { key }
}

extension Account: Differentiable {
    
}
