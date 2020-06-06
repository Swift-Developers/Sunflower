//
//  PgyerIPAController.swift
//  Sunflower
//
//  Created by Lee on 2020/4/16.
//

import Cocoa

class PgyerIPAController: ViewController<PgyerIPAView> {

    typealias Info = Analysis.IPA
    
    private var model: PgyerModel?
    private var info: Info = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNotification()
    }
    
    private func setup() {
        title = info.name
        container.set(info)
        container.set(model?.file)
        
        model?.getDetail { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                if let item = value {
                    self.container.description = item.buildUpdateDescription
                    
                } else {
                    
                }
                
            case .failure:
                print("")
            }
        }
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
        model?.upload(container.description) { (result) in
            
        }
    }
    
    static func instance(file url: URL, with info: Info) -> Self {
        let controller = instance()
        controller.model = .init("b7b9e51d9589c2e9c6002db2214111ee", file: url, with: .ipa(info))
        controller.info = info
        return controller
    }
    
    private static func instance() -> Self {
        return StoryBoard.pgyer.instance()
    }
}

extension PgyerIPAController {
    
    @objc
    private func windowCloseAction(_ sender: Notification) {
        let controller = ReceiveController.instance()
        NSApp.mainWindow?.contentViewController = controller
    }
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
