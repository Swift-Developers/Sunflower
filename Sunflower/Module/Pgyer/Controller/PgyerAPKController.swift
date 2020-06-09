//
//  PgyerAPKController.swift
//  Sunflower
//
//  Created by Lee on 2020/5/15.
//

import Cocoa

class PgyerAPKController: ViewController<PgyerAPKView> {

    typealias Info = Analysis.APK
    
    private var file: URL?
    private var info: Info = .empty
    
    var notes: String {
        get { container.notes }
        set { container.notes = newValue }
    }
    var upload: ((PgyerIPAController, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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

fileprivate extension Analysis.APK {
    
    static let empty: Self = .init(
        name: "",
        icon: #imageLiteral(resourceName: "icon_placeholder_apk"),
        package: "",
        versionCode: "",
        versionName: "",
        compileSdkVersionCode: "",
        compileSdkVersionName: "",
        platformBuildVersionCode: "",
        platformBuildVersionName: "",
        minSdkVersion: "",
        targetSdkVersion: ""
    )
}
