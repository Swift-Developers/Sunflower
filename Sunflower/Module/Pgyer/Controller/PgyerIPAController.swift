//
//  PgyerIPAController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/16.
//

import Cocoa

class PgyerIPAController: ViewController<PgyerIPAView> {

    typealias Info = Analysis.IPA
    
    private var file: URL?
    private var info: Info = .empty
    
    var notes: String {
        get { container.notes }
        set { container.notes = newValue }
    }
    var upload: ((PgyerIPAController, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNotification()
    }
    
    private func setup() {
        title = info.name
        container.set(info)
        container.set(file)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowCloseAction),
            name: NSWindow.willCloseNotification,
            object: AppDelegate.shared.window
        )
    }
    
    @IBAction func embeddedAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        let controller = ReceiveController.instance()
        NSApp.mainWindow?.contentViewController = controller
    }
    
    @IBAction func doneAction(_ sender: NSButton) {
        upload?(self, notes)
    }
    
    private static func instance() -> Self {
        return StoryBoard.pgyer.instance()
    }
    
    static func instance(file url: URL, with info: Info) -> Self {
        let controller = instance()
        controller.file = url
        controller.info = info
        return controller
    }
}

extension PgyerIPAController {
    
    @objc
    private func windowCloseAction(_ sender: Notification) {
        let controller = ReceiveController.instance()
        NSApp.mainWindow?.contentViewController = controller
    }
}

fileprivate extension PgyerModel {
    
    static let empty: PgyerModel = .init(
        .init(key: "", name: "", password: ""),
        file: .init(fileURLWithPath: ""),
        with: .ipa(.empty)
    )
}

fileprivate extension Analysis.IPA {
    
    static let empty: Self = .init(
        icon: #imageLiteral(resourceName: "icon_placeholder_ipa"),
        name: "",
        version: "",
        bundleId: "",
        bundleName: "",
        bundleVersion: "",
        creationDate: .distantPast,
        embedded: nil
    )
}
