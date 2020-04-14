//
//  ViewController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/13.
//

import Cocoa

protocol CustomViewable: NSViewController {
    associatedtype Container
    var container: Container { get }
}

extension CustomViewable  {
    var container: Container { view as! Container }
}

class ViewController<Container: NSView>: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit { print("deinit:\t\(classForCoder)") }
}

extension ViewController: CustomViewable { }
