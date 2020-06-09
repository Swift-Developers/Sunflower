//
//  SinglePickerController.swift
//  Sunflower
//
//  Created by Lee on 2020/6/6.
//

import Cocoa

class SinglePickerController: ViewController<NSView> {

    struct Item {
        let icon: NSImage
        let name: NSAttributedString
    }
    
    @IBOutlet private weak var titleLabel: NSTextField!
    @IBOutlet private weak var tableView: NSTableView!
    
    private var items: [Item] = []
    var completion: ((Int) -> Void)?
    
    override var title: String? {
        didSet {
            guard isViewLoaded else { return }
            titleLabel.stringValue = title ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.stringValue = title ?? ""
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        dismiss(self)
    }
    
    @IBAction func continueAction(_ sender: NSButton) {
        dismiss(self)
        completion?(tableView.selectedRow)
    }
    
    private static func instance() -> Self {
        return StoryBoard.picker.instance()
    }
    static func instance(_ items: [Item]) -> Self {
        let controller = instance()
        controller.items = items
        return controller
    }
}

extension SinglePickerController: NSTableViewDataSource, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: .init("cell"), owner: self) as? NSTableCellView
        cell?.imageView?.image = items[row].icon
        cell?.textField?.attributedStringValue = items[row].name
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}
