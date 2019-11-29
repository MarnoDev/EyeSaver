//
//  EventMonitor.swift
//  EyeSaver
//
//  Created by Marno on 9/14/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class EventMonitor {
    var mask: NSEvent.EventTypeMask
    var handler : (NSEvent?) -> ()
    var monitor: Any?
    
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()){
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    func start(){
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
}
