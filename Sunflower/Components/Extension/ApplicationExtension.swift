//
//  ApplicationExtension.swift
//  Sunflower
//
//  Created by Lee on 2020/4/21.
//

import AppKit

extension NSApplication {
    /// Relaunch the app.
    func relaunch() {
        NSWorkspace.shared.launchApplication(
            withBundleIdentifier: Bundle.main.bundleIdentifier!,
            options: .newInstance,
            additionalEventParamDescriptor: nil,
            launchIdentifier: nil
        )

        NSApp.terminate(nil)
    }
}
