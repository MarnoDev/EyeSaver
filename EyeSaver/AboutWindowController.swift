//
//  AboutWindowController.swift
//  EyeSaver
//
//  Created by Marno on 9/20/19.
//  Copyright © 2019 Marno All rights reserved.
//

import Cocoa

class AboutWindow:NSWindow{}

class AboutWindowController: NSWindowController {
    
    
    @IBOutlet weak var bgEffectView: NSVisualEffectView!
    @IBOutlet weak var tvVersion: NSTextField!
    @IBOutlet weak var tvCopyright: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        bgEffectView.state = .active
        bgEffectView.blendingMode = .behindWindow
        bgEffectView.material = .sidebar
        
        self.window!.level = .popUpMenu
        self.window!.collectionBehavior = [.fullScreenAuxiliary, .stationary, .canJoinAllSpaces]
        self.window!.canHide = false
        self.window!.isMovableByWindowBackground = true
        self.window!.isMovable = true
        
        let bundle = Bundle.main
        tvVersion.stringValue = "v\(bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "")(build\(bundle.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""))"
        
        tvCopyright.stringValue = bundle.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    }
    
}
