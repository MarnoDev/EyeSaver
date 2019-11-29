import Cocoa

class ConfigUtils {
    
    private var INITIAL_WORK_TIME: Double = 20 * 60
    private var INITIAL_RELAX_TIME: Double = 20
    
    let userDefaults = UserDefaults.standard
    
    private let keyIsSecondOpenApp = "keyIsFirstOpenApp"
    private let keyStartWhenMacLogin = "keyStartWhenMacLogin"
    private let keyEnableMenuBarTimer = "keyEnableMenuBarTimer"
    private let keyRightClickSkip = "keyRightClickSkip"
    private let keySpaceSkip = "keySpaceSkip"
    private let keyDisableWhenFullscreen = "keyDisableWhenFullscreen"
    private let keyWorkTime = "keyWorkTime"
    private let keyRelaxTime = "keyRelaxTime"
    private let keyHintText = "keyHintText"
    private let keyDisableWhenLockScreen = "keyDisableWhenLockScreen"
    
    var valueIsSecondOpenApp: Bool{
        willSet{
            if valueIsSecondOpenApp != newValue {
                userDefaults.set(newValue, forKey: keyIsSecondOpenApp)
            }
        }
    }
    
    // 是否开机启动
    var valueStartWhenMacLogin:Bool{
        willSet{
            if valueStartWhenMacLogin != newValue { userDefaults.set(newValue, forKey: keyStartWhenMacLogin) }
        }
    }
    
    // 是否显示状态栏计时
    var valueEnableMenuBarTimer: Bool{
        willSet{
            if valueEnableMenuBarTimer != newValue { userDefaults.set(newValue, forKey: keyEnableMenuBarTimer) }
        }
    }
    
    // 鼠标右键双击跳过
    var valueEnableRightClickSkip: Bool{
        willSet{
            if valueEnableRightClickSkip != newValue { userDefaults.set(newValue, forKey: keyRightClickSkip)}
        }
    }
    
    // 长按空格跳过
    var valueEnableSpaceSkip: Bool{
        willSet{
            if valueEnableSpaceSkip != newValue { userDefaults.set(newValue, forKey: keySpaceSkip)}
        }
    }
    
    // 全屏时禁用
    var valueDisableWhenFullscreen: Bool{
        willSet{
            if valueDisableWhenFullscreen != newValue { userDefaults.set(newValue, forKey: keyDisableWhenFullscreen)}
        }
    }
    
    // 工作时长
    var valueWorkTime:Double{
        willSet{
            if valueWorkTime != newValue {
                userDefaults.set(newValue, forKey: keyWorkTime)}
        }
    }
    
    // 休息时长
    var valueRelaxTime: Double{
        willSet{
            if valueRelaxTime != newValue { userDefaults.set(newValue, forKey: keyRelaxTime)}
        }
    }
    
    // 提示语
    var valueHintText:String {
        willSet{
            if valueHintText != newValue { userDefaults.set(newValue, forKey: keyHintText)}
        }
    }
    
    var valueDisableWhenLockScreen:Bool{
       willSet{
            if valueDisableWhenLockScreen != newValue { userDefaults.set(newValue, forKey: keyDisableWhenLockScreen)}
        }
    }
    
    static let shared = ConfigUtils()
    
    private init(){
        valueIsSecondOpenApp = userDefaults.bool(forKey: keyIsSecondOpenApp)
        
        // 判断是否是初次打开应用
        if !valueIsSecondOpenApp { // 是
            valueStartWhenMacLogin = false
            valueEnableMenuBarTimer = true
            valueEnableRightClickSkip = true
            valueEnableSpaceSkip = true
            valueDisableWhenFullscreen = false
            valueWorkTime = INITIAL_WORK_TIME
            valueRelaxTime = INITIAL_RELAX_TIME
            valueHintText = "站起来，看远方"
            valueDisableWhenLockScreen = true
            userDefaults.set(true, forKey: keyIsSecondOpenApp)
            userDefaults.set(valueStartWhenMacLogin, forKey: keyStartWhenMacLogin)
            userDefaults.set(valueEnableMenuBarTimer, forKey: keyEnableMenuBarTimer)
            userDefaults.set(valueEnableRightClickSkip, forKey: keyRightClickSkip)
            userDefaults.set(valueEnableSpaceSkip, forKey: keySpaceSkip)
            userDefaults.set(valueDisableWhenFullscreen, forKey: keyDisableWhenFullscreen)
            userDefaults.set(valueWorkTime, forKey: keyWorkTime)
            userDefaults.set(valueRelaxTime, forKey: keyRelaxTime)
            userDefaults.set(valueHintText, forKey: keyHintText)
            userDefaults.set(valueDisableWhenLockScreen, forKey: keyDisableWhenLockScreen)
        } else { // 不是
            valueStartWhenMacLogin = userDefaults.bool(forKey: keyStartWhenMacLogin)
            valueEnableMenuBarTimer = userDefaults.bool(forKey: keyEnableMenuBarTimer)
            valueEnableRightClickSkip = userDefaults.bool(forKey: keyRightClickSkip)
            valueEnableSpaceSkip = userDefaults.bool(forKey: keySpaceSkip)
            valueDisableWhenFullscreen = userDefaults.bool(forKey: keyDisableWhenFullscreen)
            valueWorkTime = userDefaults.double(forKey: keyWorkTime)
            valueRelaxTime = userDefaults.double(forKey: keyRelaxTime)
//            valueWorkTime = 10
//            valueRelaxTime = 5
            valueHintText = userDefaults.string(forKey: keyHintText)!
            valueDisableWhenLockScreen = userDefaults.bool(forKey: keyDisableWhenLockScreen)
        }
    }
    
    func start(){}

}
