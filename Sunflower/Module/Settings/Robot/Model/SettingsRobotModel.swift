//
//  SettingsRobotModel.swift
//  Sunflower
//
//  Created by Lee on 2020/5/14.
//

import AppKit

class SettingsRobotModel {
    
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
            let models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
            handle(.wechat, with: models.map { .init(name: $0.name, key: $0.key) })
        }
        do {
            let models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
            handle(.feishu, with: models.map { .init(name: $0.name, key: $0.key) })
        }
    }
    
    /// 设置监听
    private func setupObservation() {
        do {
            let observation = UserDefaults.RobotInfo.observe(forKey: .wechat) {
                [weak self] (old: [Robot.Wechat]?, new: [Robot.Wechat]?) in
                self?.handle(.wechat, with: new?.map { .init(name: $0.name, key: $0.key) } ?? [])
            }
            observations.append(observation)
        }
        do {
            let observation = UserDefaults.RobotInfo.observe(forKey: .feishu) {
                [weak self] (old: [Robot.Feishu]?, new: [Robot.Feishu]?) in
                self?.handle(.feishu, with: new?.map { .init(name: $0.name, key: $0.key) } ?? [])
            }
            observations.append(observation)
        }
    }
    
    private func handle(_ type: Robot, with items: [Section.Item]) {
        guard self.items(type: type) != items  else {
            return
        }
        update(type, with: items)
        changed?(sections)
    }
}

extension SettingsRobotModel {
    
    /// 移除某项数据
    /// - Parameters:
    ///   - type: 类型
    ///   - item: 子项
    /// - Returns: 最新数据
    func remove(type: Robot, with item: Section.Item) {
        switch type {
        case .wechat:
            var models: [Robot.Wechat] = UserDefaults.RobotInfo.model(forKey: .wechat) ?? []
            models.removeAll { $0.key == item.key }
            UserDefaults.RobotInfo.set(model: models, forKey: .wechat)
            
        case .feishu:
            var models: [Robot.Feishu] = UserDefaults.RobotInfo.model(forKey: .feishu) ?? []
            models.removeAll { $0.key == item.key }
            UserDefaults.RobotInfo.set(model: models, forKey: .feishu)
        }
    }
}

extension SettingsRobotModel {
    
    private func items(type: Robot) -> [Section.Item] {
        sections.first(where: { $0.type == type })?.items ?? []
    }
    
    private func update(_ type: Robot, with items: [Section.Item]) {
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
}

extension SettingsRobotModel {
    
    struct Section: Equatable {
        let type: Robot
        var items: [Item]
        
        struct Item: Equatable {
            let name: String
            let key: String
        }
    }
}
