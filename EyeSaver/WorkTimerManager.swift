//
//  TimerManager.swift
//  EyeSaver
//
//  Created by Marno on 9/15/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class WorkTimerManager {
    
    var countTimeLength: Double
    var initialTimeLength: Double
    var countTimer: Timer? = nil
    var delegates = [TimerTickDelegate]()
    var isManualStop: Bool = false
    
    static let shared = WorkTimerManager()
    
    private init(){
        self.countTimeLength = ConfigUtils.shared.valueWorkTime
        self.initialTimeLength = self.countTimeLength
    }
    
    func addDelegate(delegate:TimerTickDelegate){
        delegates.append(delegate)
    }
    
    func startTimer(){
        for d in self.delegates { d.onStart(initialTime: countTimeLength) }
        countTimer?.invalidate()
        countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            if self.countTimeLength == 0{
                timer.invalidate()
                for d in self.delegates { d.onFinish() }
            }else{
                self.countTimeLength -= 1
                for d in self.delegates { d.onTick(currentTime: self.countTimeLength)}
            }
        })
    }
    
    func stopTimer(isManualStop:Bool = false){
        self.isManualStop = isManualStop
        countTimer?.invalidate()
        for d in self.delegates { d.onPause() }
    }
    
    func resetTimer(directPlay:Bool = true){
        stopTimer()
        countTimeLength = ConfigUtils.shared.valueWorkTime
        for d in self.delegates { d.onReset() }
        if directPlay{ startTimer() }
    }
    
    func skipTimer(){
        for d in self.delegates { d.onFinish() }
    }
    
}

protocol TimerTickDelegate {
    func onTick(currentTime: Double)
    func onStart(initialTime: Double)
    func onPause()
    func onFinish()
    func onReset()
}

extension TimerTickDelegate{
    func onTick(currentTime: Double) {}
    func onStart(initialTime: Double) {}
    func onPause() {}
    func onFinish() {}
    func onReset(){}
}
