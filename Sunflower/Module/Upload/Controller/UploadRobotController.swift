//
//  UploadRobotController.swift
//  Sunflower
//
//  Created by Lee on 2020/9/1.
//

import Cocoa
import DifferenceKit

class UploadRobotController: NSViewController {

    typealias Section = SettingsRobotModel.Section
    
    @IBOutlet weak var listView: NSCollectionView!
    @IBOutlet weak var doneButton: NSButton!
    
    private let model = SettingsRobotModel()
    private var sections: [ArraySection<Robot, Section.Item>] = []
    private var selectes: [IndexPath] = [] {
        didSet {
            doneButton.isEnabled = !selectes.isEmpty
        }
    }
    
    var skip: (() -> Void)?
    var done: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadData()
    }
    
    private func setup() {
        listView.register(NSNib(nibNamed: "UploadRobotItem", bundle: nil), forItemWithIdentifier: .init("cell"))
        listView.register(UploadRobotSectionHeader.self, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: .init("header"))
        
        model.changed = { [weak self] new in
            guard let self = self else { return }
            // 刷新列表
            let source = self.sections
            let target = new.map {
                ArraySection(model: $0.type, elements: $0.items)
            }
            let changeset = StagedChangeset(source: source, target: target)
            self.listView.reload(using: changeset) { (data) in
                self.sections = data
            }
            
            // 同步选中项
            self.selectes = self.selectes.compactMap {
                let type = source[$0.section].model
                let item = source[$0.section].elements[$0.item]
                guard
                    let sectionIndex = target.firstIndex(where: { $0.model == type }),
                    let itemIndex = target[sectionIndex].elements.firstIndex(where: { $0.key == item.key }) else {
                    return nil
                }
                return IndexPath(item: itemIndex, section: sectionIndex)
            }
            self.listView.selectItems(at: .init(self.selectes), scrollPosition: .init())
        }
    }
    
    private func loadData() {
        sections = model.datas.map {
            ArraySection(model: $0.type, elements: $0.items)
        }
        listView.reloadData()
        
        // 同步选中项
        selectes = Upload.robots.reduce(into: []) {
            let type = Robot(rawValue: $1.key)
            $0 += $1.value.compactMap { (key) in
                guard
                    let sectionIndex = sections.firstIndex(where: { $0.model == type }),
                    let itemIndex = sections[sectionIndex].elements.firstIndex(where: { $0.key == key }) else {
                    return nil
                }
                return IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        listView.selectItems(at: .init(selectes), scrollPosition: .init())
    }
    
    @IBAction func skipAction(_ sender: Any) {
        dismiss(self)
        skip?()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(self)
        
        // 同步选中项
        var temp: [String: [String]] = [:]
        for indexPath in selectes {
            let section = sections[indexPath.section]
            var keys = temp[section.model.rawValue] ?? []
            keys.append(section.elements[indexPath.item].key)
            temp[section.model.rawValue] = keys
        }
        Upload.robots = temp
        
        done?()
    }
    
    static func instance() -> Self {
        return StoryBoard.upload.instance()
    }
}

extension UploadRobotController: NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return .init(width: collectionView.width, height: 40)
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

extension UploadRobotController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].elements.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .init("cell"), for: indexPath) as! UploadRobotItem
        let item = sections[indexPath.section].elements[indexPath.item]
        cell.set(item.key, with: item.name)
        cell.swicth = { [weak self] (selected) in
            guard let self = self else { return }
            if selected {
                self.selectes.append(indexPath)
                
            } else {
                self.selectes.removeAll(indexPath)
            }
            
            collectionView.selectItems(at: .init(self.selectes), scrollPosition: .init())
        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case NSCollectionView.elementKindSectionHeader:
            let header = collectionView.makeSupplementaryView(
                ofKind: kind,
                withIdentifier: .init("header"),
                for: indexPath
            ) as! UploadRobotSectionHeader
            let model = sections[indexPath.section].model
            header.set(model.icon, with: model.name)
            return header
            
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        selectes = .init(indexPaths.union(selectes))
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        selectes = .init(Set(selectes).subtracting(indexPaths))
    }
}
