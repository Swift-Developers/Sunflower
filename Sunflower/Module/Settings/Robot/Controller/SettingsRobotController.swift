//
//  SettingsRobotController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import Cocoa
import Preferences
import DifferenceKit

class SettingsRobotController: ViewController<SettingsRobotView> {

    typealias Section = SettingsRobotModel.Section
    
    private let model = SettingsRobotModel()
    private var sections: [ArraySection<Robot, Section.Item>] = []
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
            Robot.allCases.map({ .init(icon: $0.icon, name: .init(string: $0.name)) })
        )
        controller.completion = { [weak self] index in
            let controller = SettingsRobotCreateController.instance(Robot.allCases[index])
            self?.presentAsSheet(controller)
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

extension SettingsRobotController {
    
    private func showInfo(type: Robot, with key: String) {
        emptyInfo()
        
        switch type {
        case .wechat:
            let controller = SettingsRobotWechatInfoController.instance(key)
            add(child: controller, to: container.infoView)
            currentInfoController = controller
            
        case .feishu:
            let controller = SettingsRobotFeishuInfoController.instance(key)
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

extension SettingsRobotController: NSCollectionViewDelegateFlowLayout {
    
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

extension SettingsRobotController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .init("cell"), for: indexPath) as! SettingsRobotItem
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
            ) as! SettingsRobotSectionHeader
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

extension SettingsRobotController: PreferencePane {
    
    var preferencePaneIdentifier: Preferences.PaneIdentifier { .robot }
    
    var preferencePaneTitle: String { "机器人" }
    
    var toolbarItemIcon: NSImage { NSImage(named: NSImage.advancedName) ?? .init() }
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

extension SettingsRobotModel.Section.Item: Differentiable {
    
    var differenceIdentifier: String { key }
}

extension Robot: Differentiable {
    
}
