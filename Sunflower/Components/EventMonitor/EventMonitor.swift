//
//  EventMonitor.swift
//  Sunflower
//
//  Created by Lee on 2020/4/20.
//

import AppKit

class EventMonitor {
    
    private var monitor: Any?
    private let handler: (NSEvent) -> Void
    private let mask: NSEvent.EventTypeMask
    
    public init(_ mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    public func start() {
       monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() {
        guard let monitor = monitor else {
            return
        }
        NSEvent.removeMonitor(monitor)
    }
    
    deinit {
        stop()
    }
}
