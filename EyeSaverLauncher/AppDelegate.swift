//
//  AppDelegate.swift
//  EyeSaverLancher
//
//  Created by Marno on 9/19/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainAppIdentifier = "cn.marno.eyesaver"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

        if isRunning {
            self.terminate()
        }else{
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: Notification.Name("killLauncher"),
                                                                object: mainAppIdentifier)

            let url = [Int](repeating: 0, count: 4).reduce(Bundle.main.bundleURL) { (url, _) -> URL in
                url.deletingLastPathComponent()
            }

            try? NSWorkspace.shared.launchApplication(at: url, options: [.withoutActivation], configuration: [:])
        }
        
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
    
}

