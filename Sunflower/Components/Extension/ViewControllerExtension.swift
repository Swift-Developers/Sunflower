//
//  ViewControllerExtension.swift
//  Sunflower
//
//  Created by Lee on 2020/4/28.
//

import AppKit

extension NSViewController {
    
    /// 添加子控制器
    /// - Parameter controller: 控制器
    /// - Parameter container: 容器视图 默认为父控制器view
    open func add(child controller: NSViewController, to container: NSView? = .none) {
        addChild(controller)
        (container ?? view)?.addSubview(controller.view)
        controller.view.frame = (container ?? view).bounds
        controller.view.autoresizingMask = [.width, .height]
    }
    
    /// 从父控制器移除
    open func removeFromParentController() {
        view.removeFromSuperview()
        removeFromParent()
    }
}
