//
//  DateTimeUtils.swift
//  EyeSaver
//
//  Created by Marno on 9/15/19.
//  Copyright © 2019 Marno All rights reserved.
//

class TimeUtils {
    
    private init(){}
    
    // 把秒数格式化为 00:00:00 或 00:00
    static func convertSec2Min(time:Double, needHour:Bool = false) ->String {
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return needHour ? "\(hoursText):\(minutesText):\(secondsText)" : "\(minutesText):\(secondsText)"
    }
    
}
