//
//  AppDelegate.swift
//  EyeSaver
//
//  Created by Marno on 9/14/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa
import UserNotifications
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSWindowDelegate,TimerTickDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var popover: NSPopover!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // clearUserDefaults()
        ConfigUtils.shared.start()
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("statusIcon"))
            button.imagePosition = NSControl.ImagePosition.imageLeading
            button.action = #selector(togglePopover)
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(event!)
            }
        }
        
        autoLaunch()
        
        // 监听是否显示状态栏时间
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(hideMenuBarTimer), name: NSNotification.Name(rawValue: "cn.marno.enableMenuBarTimer"), object: nil)
        
        WorkTimerManager.shared.addDelegate(delegate: self)
        WorkTimerManager.shared.startTimer()
        
        addScreenLockerListener()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    // 添加对锁屏和解锁的监听
    func addScreenLockerListener(){
        // 屏幕锁定
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(screenLocked), name: NSNotification.Name(rawValue: "com.apple.screenIsLocked"), object: nil)
  
        // 屏幕解锁
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(screenUnlocked), name: NSNotification.Name(rawValue: "com.apple.screenIsUnlocked"), object: nil)
   
    }
    
    // 开机自启动
    func autoLaunch() {
        let launcherAppId = "cn.marno.EyeSaverLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, ConfigUtils.shared.valueStartWhenMacLogin)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: Notification.Name("killLauncher"), object: Bundle.main.bundleIdentifier!)
        }
    }
    
    @objc func screenLocked(){
        if ConfigUtils.shared.valueDisableWhenLockScreen {
            if(!WorkTimerManager.shared.isManualStop){ WorkTimerManager.shared.stopTimer(isManualStop: false)
            }
        }
    }
    
    @objc func screenUnlocked(){
        if ConfigUtils.shared.valueDisableWhenLockScreen {
            if(!WorkTimerManager.shared.isManualStop) {
                WorkTimerManager.shared.startTimer()
            }
        }
    }
    
    @objc func hideMenuBarTimer(){
        onTick(currentTime:WorkTimerManager.shared.countTimeLength)
    }
    
    @objc func showPopover(_ sender: AnyObject) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    @objc func closePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    @objc func togglePopover(_ sender: AnyObject) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func onTick(currentTime: Double) {
        if let button = statusItem.button {
            button.title = ConfigUtils.shared.valueEnableMenuBarTimer ? TimeUtils.convertSec2Min(time: currentTime):""
        }
    }
    
    func onFinish() {
        var windowControllers = [RelaxRemindWindowController]()
        for screen in NSScreen.screens {
            let relaxWindowController = RelaxRemindWindowController(windowNibName: "RelaxRemindWindowController")
            relaxWindowController.window?.setFrame(screen.frame, display: false)
            windowControllers.append(relaxWindowController)
        }
        for contronller in windowControllers{
            contronller.show(controllers: windowControllers)
        }
        if popover.isShown { closePopover(popover) }
    }
    
    func onReset(){
        if let button = statusItem.button {
            button.title = TimeUtils.convertSec2Min(time: ConfigUtils.shared.valueWorkTime)
        }
    }
    
    // 测试用
    func clearUserDefaults(){
        let userDefaults = UserDefaults.standard
        let keys = userDefaults.dictionaryRepresentation()
        for key in keys {
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
    }
}

