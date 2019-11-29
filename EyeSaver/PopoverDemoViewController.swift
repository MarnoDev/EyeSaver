//
//  PopoverDemoViewController.swift
//  EyeSaver
//
//  Created by Marno on 9/14/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class PopoverDemoViewController: NSViewController, NSWindowDelegate, TimerTickDelegate, NSTextFieldDelegate {
        
    // 组件绑定
    @IBOutlet weak var tvTimeDisplay: NSTextField! // 显示计时
    @IBOutlet weak var btnStart: NSButton! // 开始
    @IBOutlet weak var btnSkip: NSButton! // 跳过
    @IBOutlet weak var btnReset: NSTextField! // 重置
    @IBOutlet weak var barView: OGCircularBarView! // 进度
    @IBOutlet weak var segment: NSSegmentedControl! // tab 控制
    @IBOutlet weak var tabView: NSTabView! // tab 页面
    @IBOutlet weak var tvWorkTimeLength: NSTextField! // 设置：工作时长显示
    @IBOutlet weak var tvRelaxTimeLength: NSTextField! // 设置：休息时长显示
    @IBOutlet weak var tvStopIntervalTime: NSTextField! // 计时：暂停时长显示
    @IBOutlet weak var sliderStopTimeInterval: NSSlider! // 计时：选择恢复计时时长
    @IBOutlet weak var sliderWorkTime: NSSlider! // 设置：选择工作时长
    @IBOutlet weak var sliderRelaxTime: NSSlider! // 设置：选择休息时长
    @IBOutlet weak var btnEnableRightClick: NSButton! // 设置：启动双击跳过休息
    @IBOutlet weak var btnEnableSpace: NSButton! // 设置：启用空格跳过休息
    @IBOutlet weak var btnEnableMenubarTimer: NSButton! // 设置：启用状态栏显示倒计时
    @IBOutlet weak var btnStartWhenMacLogin: NSButton! // 设置：开机启动
    @IBOutlet weak var inputHintText: NSTextField!
    @IBOutlet weak var btnDisableWhenLockScreen: NSButton! // 设置：锁屏暂停
    
    var initialStopTime:Double = 0
    var isPlaying:Bool = false
    var isManualPause:Bool = false
    var countStopTimer:Timer? = nil
    let aboutWindowController = AboutWindowController(windowNibName: "AboutWindowController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkTimerManager.shared.addDelegate(delegate: self)
        initProgressView()
        initViewState()
    }
    
    override var representedObject: Any? {
        didSet {}
    }
    
    // 初始化组件的值
    func initViewState(){
    sliderWorkTime.intValue = Int32(ConfigUtils.shared.valueWorkTime/60)
        sliderRelaxTime.intValue = Int32(ConfigUtils.shared.valueRelaxTime)
        tvWorkTimeLength.stringValue = "\(sliderWorkTime.intValue)m"
        tvRelaxTimeLength.stringValue = "\(sliderRelaxTime.intValue)s"
        tvTimeDisplay.stringValue = TimeUtils.convertSec2Min(time: ConfigUtils.shared.valueWorkTime)
        
        btnEnableRightClick.state = ConfigUtils.shared.valueEnableRightClickSkip ? .on : .off
        btnEnableSpace.state = ConfigUtils.shared.valueEnableSpaceSkip ? .on : .off
        btnEnableMenubarTimer.state = ConfigUtils.shared.valueEnableMenuBarTimer ? .on : .off
        btnStartWhenMacLogin.state = ConfigUtils.shared.valueStartWhenMacLogin ? .on : .off
        
        inputHintText.isBordered = true
        inputHintText.placeholderString = ConfigUtils.shared.valueHintText
        inputHintText.delegate = self
        
        btnDisableWhenLockScreen.state = ConfigUtils.shared.valueDisableWhenLockScreen ? .on : .off
    }
    
    // 初始化进度条
    func initProgressView(){
        let green = NSColor(calibratedRed: 8/255, green: 193/255, blue: 97/255, alpha: 1)
        barView.addBarBackground(startAngle: 90, endAngle: -270, radius: 80, width: 26, color: green.withAlphaComponent(0.1))
        barView.addBar(startAngle: 90, endAngle: -270, progress: 0, radius: 80, width: 26, color: green, animationDuration: 1.5, glowOpacity: 0.4, glowRadius: 6)
        barView.bars.last?.animateProgress(0.001, duration: 0)
    }
    
    func onTick(currentTime: Double) {
        isPlaying = true
        updateBtnStartImage()
        tvTimeDisplay.stringValue = TimeUtils.convertSec2Min(time: currentTime)
        let totalTime = ConfigUtils.shared.valueWorkTime
        barView.bars.last?.animateProgress(CGFloat(1.0 - currentTime/totalTime), duration: 1)
    }
    
    func onStart(initialTime: Double) {
        isPlaying = true
        updateBtnStartImage()
    }
    
    func onPause() {
        isPlaying = false
        updateBtnStartImage()
    }
    
    func onFinish() {
        isPlaying = false
        updateBtnStartImage()
    }
    
    func onReset() {
        updateBtnStartImage()
        tvTimeDisplay.stringValue = TimeUtils.convertSec2Min(time: ConfigUtils.shared.valueWorkTime)
        barView.bars.last?.progress = 0.001
        tvStopIntervalTime.stringValue = "0:00:00"
        sliderStopTimeInterval.doubleValue = 0.0
    }
    
    func updateBtnStartImage(){
        btnStart.image = isPlaying ? #imageLiteral(resourceName: "pauseIcon") : #imageLiteral(resourceName: "startIcon")
        sliderStopTimeInterval.isEnabled = !isPlaying
        tvStopIntervalTime.isEnabled = !isPlaying
    }
    
    @IBAction func openHelpLink(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://mp.weixin.qq.com/mp/homepage?__biz=MzA3NjgyNzk2Mw==&hid=9&sn=a8659578289ebda32f75ac0949ea1258")!)
    
    }
    
    @IBAction func openAbout(_ sender: Any) {
        aboutWindowController.showWindow(aboutWindowController)
    }
    
    // 自定义提示语
    func controlTextDidChange(_ obj: Notification) {
        let afterTrimString = inputHintText.stringValue.trimmingCharacters(in: .whitespaces)
        if afterTrimString.count == 0 { return }
        
//        if afterTrimString.count > 8 {
//            inputHintText.stringValue = String(afterTrimString.prefix(8))
//        }
        ConfigUtils.shared.valueHintText =  inputHintText.stringValue
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        inputHintText.placeholderString = ConfigUtils.shared.valueHintText
    }
    
    // 锁屏时是否暂停
    @IBAction func disableWhenLockScreen(_ sender: Any) {
        let isEnable = btnDisableWhenLockScreen.state == .on
        ConfigUtils.shared.valueDisableWhenLockScreen = isEnable
    }
    
    // 状态栏是否显示计时
    @IBAction func enableMenubarTimer(_ sender: Any) {
        let isEnable = btnEnableMenubarTimer.state == .on
        ConfigUtils.shared.valueEnableMenuBarTimer = isEnable
        DistributedNotificationCenter.default().post(name: NSNotification.Name("cn.marno.enableMenuBarTimer"), object: nil)
    }
    
    // 启用双击跳过
    @IBAction func enableRightClick(_ sender: Any) {
        let isEnable = btnEnableRightClick.state == .on
        ConfigUtils.shared.valueEnableRightClickSkip = isEnable
    }
    
    // 启用长按空格跳过
    @IBAction func enableSpace(_ sender: Any) {
        let isEnable = btnEnableSpace.state == .on
        ConfigUtils.shared.valueEnableSpaceSkip = isEnable
    }

    // 选择停止的时长
    @IBAction func selectStopInterval(_ sender: Any) {
        initialStopTime = sliderStopTimeInterval.doubleValue * 3600
        tvStopIntervalTime.stringValue = TimeUtils.convertSec2Min(time:initialStopTime, needHour: true)
        if initialStopTime != 0.0 {
            countDownStopTime()
        }else{
            countStopTimer?.invalidate()
        }
    }
    
    // 选择休息时长
    @IBAction func selectRelaxTimeLength(_ sender: Any) {
        tvRelaxTimeLength.stringValue = "\(sliderRelaxTime.intValue)s"
        ConfigUtils.shared.valueRelaxTime = sliderRelaxTime.doubleValue
    }
    
    // 选择工作时长
    @IBAction func selectWorkTimeLength(_ sender: Any) {
        tvWorkTimeLength.stringValue = "\(sliderWorkTime.intValue)m"
        ConfigUtils.shared.valueWorkTime = sliderWorkTime.doubleValue * 60
    }
    
    // 开启启动
    @IBAction func launchAtLogin(_ sender: Any) {
        let isEnable = btnStartWhenMacLogin.state == .on
        ConfigUtils.shared.valueStartWhenMacLogin = isEnable
    }
    
    // 切换 tab
    @IBAction func segmentControlClick(_ sender: Any) {
        tabView.selectTabViewItem(at: segment.selectedSegment)
    }
    
    // 退出应用
    @IBAction func quitApp(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    // 切换计时开关状态
    @IBAction func toggleTimer(_ sender: Any) {
        if !isPlaying {
            WorkTimerManager.shared.startTimer()
            countStopTimer?.invalidate()
            initialStopTime = sliderStopTimeInterval.doubleValue * 3600
            tvStopIntervalTime.stringValue = TimeUtils.convertSec2Min(time:initialStopTime, needHour: true)
        }else{
            WorkTimerManager.shared.stopTimer(isManualStop: true)
            if sliderStopTimeInterval.doubleValue != 0.0 {
                countDownStopTime()
            }
        }
    }
    
    // 跳过计时
    @IBAction func skipTimer(_ sender: Any) {
        WorkTimerManager.shared.skipTimer()
    }
    
    // 重置计时
    @IBAction func resetTimer(_ sender: Any) {
        WorkTimerManager.shared.resetTimer(directPlay:isPlaying)
    }
        
    // 开始暂停倒计时
    func countDownStopTime() {
        countStopTimer?.invalidate()
        countStopTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            if self.initialStopTime == 0{
                timer.invalidate()
                self.initialStopTime = self.sliderStopTimeInterval.doubleValue * 3600
                self.tvStopIntervalTime.stringValue = TimeUtils.convertSec2Min(time:self.initialStopTime, needHour: true)
                self.toggleTimer(-1)
            }else{
                self.initialStopTime -= 1
            }
            self.tvStopIntervalTime.stringValue = TimeUtils.convertSec2Min(time: self.initialStopTime,needHour: true)
        })
    }
    
}
