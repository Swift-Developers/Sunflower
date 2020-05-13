//
//  SettingsAccountModel.swift
//  Sunflower
//
//  Created by Lee on 2020/4/27.
//

import AppKit

class SettingsAccountModel {
    
    /// 数据
    var datas: [Section] { sections }
    /// 数据变更回调
    var changed: (([Section]) -> Void)?
    
    private var sections: [Section] = []
    private var observations: [UserDefaultsObservation] = []
    
    init() {
        setup()
        setupObservation()
    }
    
    /// 设置数据
    private func setup() {
        do {
            let models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
            handle(.pgyer, with: models.map { .init(name: $0.name, key: $0.key) })
        }
        do {
            let models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
            handle(.firim, with: models.map { .init(name: $0.name, key: $0.key) })
        }
    }
    
    /// 设置监听
    private func setupObservation() {
        do {
            let observation = UserDefaults.AccountInfo.observe(forKey: .pgyer) {
                [weak self] (old: [Account.Pgyer]?, new: [Account.Pgyer]?) in
                self?.handle(.pgyer, with: new?.map { .init(name: $0.name, key: $0.key) } ?? [])
            }
            observations.append(observation)
        }
        do {
            let observation = UserDefaults.AccountInfo.observe(forKey: .firim) {
                [weak self] (old: [Account.Firim]?, new: [Account.Firim]?) in
                self?.handle(.firim, with: new?.map { .init(name: $0.name, key: $0.key) } ?? [])
            }
            observations.append(observation)
        }
    }
    
    private func handle(_ type: Account, with items: [Section.Item]) {
        guard self.items(type: type) != items  else {
            return
        }
        update(type, with: items)
        changed?(sections)
    }
}

extension SettingsAccountModel {
    
    /// 移除某项数据
    /// - Parameters:
    ///   - type: 类型
    ///   - item: 子项
    /// - Returns: 最新数据
    func remove(type: Account, with item: Section.Item) {
        switch type {
        case .pgyer:
            var models: [Account.Pgyer] = UserDefaults.AccountInfo.model(forKey: .pgyer) ?? []
            models.removeAll { $0.key == item.key }
            UserDefaults.AccountInfo.set(model: models, forKey: .pgyer)
            
        case .firim:
            var models: [Account.Firim] = UserDefaults.AccountInfo.model(forKey: .firim) ?? []
            models.removeAll { $0.key == item.key }
            UserDefaults.AccountInfo.set(model: models, forKey: .firim)
        }
    }
}

extension SettingsAccountModel {
    
    private func items(type: Account) -> [Section.Item] {
        sections.first(where: { $0.type == type })?.items ?? []
    }
    
    private func update(_ type: Account, with items: [Section.Item]) {
        if let index = sections.firstIndex(where: { $0.type == type }) {
            if items.isEmpty {
                sections.remove(at: index)
                
            } else {
                var item = sections[index]
                item.items = items
                sections[index] = item
            }
            
        } else {
            sections.append(.init(type: type, items: items))
        }
    }
    
    @discardableResult
    private func remove(_ type: Account, with item: Section.Item) -> [Section] {
        guard let i = sections.firstIndex(where: { $0.type == type }) else {
            return sections
        }
        
        var section = sections[i]
        section.items.removeAll(item)
        if section.items.isEmpty {
            sections.remove(at: i)
            
        } else {
            sections[i] = section
        }
        
        return sections
    }
}

extension SettingsAccountModel {
    
    struct Section: Equatable {
        let type: Account
        var items: [Item]
        
        struct Item: Equatable {
            let name: String
            let key: String
        }
    }
}
