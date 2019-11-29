//
//  RelaxRemindWindowController.swift
//  EyeSaver
//
//  Created by Marno on 9/14/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class RelaxRemindWindow:NSWindow{}

class RelaxRemindWindowController: NSWindowController, NSWindowDelegate,TimerTickDelegate {
    
    @IBOutlet weak var rectView: RectangleView!
    @IBOutlet weak var tvRelaxTime: NSTextField!
    @IBOutlet weak var tvHint: NSTextField!
    
    var controllers = [RelaxRemindWindowController]()
    var countRelaxTimer: Timer? = nil
    var isWantStopTimer: Bool = false // 用户手动暂停计时
    var isScreenLock:Bool = false // 屏幕是否锁定状态
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        addEventListener()
        addScreenLockerListener()
        initWindow()
        
        RelaxTimerManager.shared.addDelegate(delegate: self)
        RelaxTimerManager.shared.startTimer()
    }
    
    func addEventListener(){
        // 添加对键盘的监听
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
        // 添加对右键点击的监听
        NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown){ (aEvent) -> NSEvent? in
            self.rightMouseDown(with: aEvent)
            return aEvent
        }
    }
    
    // 添加对锁屏和解锁的监听
    func addScreenLockerListener(){
        // 屏幕锁定
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(screenLocked), name: NSNotification.Name(rawValue: "com.apple.screenIsLocked"), object: nil)
        
        
        // 屏幕解锁
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(screenUnlocked), name: NSNotification.Name(rawValue: "com.apple.screenIsUnlocked"), object: nil)
    }
    
    @objc func screenLocked(){
        if ConfigUtils.shared.valueDisableWhenLockScreen {
            isScreenLock = true
        }
        
    }
    
    @objc func screenUnlocked(){
        if ConfigUtils.shared.valueDisableWhenLockScreen {
            isScreenLock = false
        }
    }
    
    func initWindow(){
        self.window!.styleMask = .borderless
        self.window!.hasShadow = false
        self.window!.level = .popUpMenu
        self.window!.isOpaque = false
        self.window!.collectionBehavior = [.fullScreenAuxiliary, .stationary, .canJoinAllSpaces]
        self.window!.canHide = false
        
        self.window!.backgroundColor = .clear
        self.window!.isMovableByWindowBackground = false
        self.window!.isMovable = false
        
        //        tvHint.autoresizingMask = .height
        //        tvHint.sizeToFit()
    }
    
    
    
    // 右键双击关闭
    override func rightMouseDown(with event: NSEvent) {
        if ConfigUtils.shared.valueEnableRightClickSkip && event.clickCount == 2 {
            closeAllWindow()
        }
    }
    
    // 长按空格关闭（连按3次）
    override func keyDown(with event: NSEvent) {
        if ConfigUtils.shared.valueEnableSpaceSkip && event.characters == " " && event.isARepeat {
            closeAllWindow()
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        if !isWantStopTimer {
            WorkTimerManager.shared.resetTimer(directPlay: !isScreenLock)
        }
    }
    
    func show(controllers:[RelaxRemindWindowController]){
        isWantStopTimer = false
        showWindow(self.window)
        self.window!.orderFrontRegardless()
        self.controllers = controllers
        showBgAlphaAnimation(controllers: controllers)
    }
    
    // 显示渐变动画
    public func showBgAlphaAnimation(controllers:[RelaxRemindWindowController]) {
        tvHint.stringValue = ConfigUtils.shared.valueHintText
        rectView.alphaValue = 0.0
        NSAnimationContext.endGrouping()
        NSAnimationContext.runAnimationGroup({(context) in
            
            context.duration = 1
            let timingFunc = CAMediaTimingFunction(name: .easeInEaseOut)
            context.timingFunction = timingFunc
            self.rectView.animator().setFrameOrigin(NSMakePoint(0, 0))
            self.rectView.animator().alphaValue = 0.95
            
        })
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        closeAllWindow()
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        isWantStopTimer = true
        closeAllWindow()
        WorkTimerManager.shared.resetTimer(directPlay: false)
    }
    
    func onStart(initialTime: Double) {
        self.tvRelaxTime.stringValue = TimeUtils.convertSec2Min(time: initialTime)
    }
    
    func onTick(currentTime: Double) {
        self.tvRelaxTime.stringValue = TimeUtils.convertSec2Min(time: currentTime)
    }
    
    func onFinish() {
        closeAllWindow()
    }
    
    func closeAllWindow(){
        for wc in controllers {wc.window?.close()}
        RelaxTimerManager.shared.resetTimer(directPlay: false)
    }
}
