//
//  TimerManager.swift
//  EyeSaver
//
//  Created by Marno on 9/15/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class RelaxTimerManager {
    
    var countTimeLength: Double
    var initialTimeLength: Double
    var countTimer: Timer? = nil
    var delegates = [TimerTickDelegate]()
    
    static let shared = RelaxTimerManager()
    
    private init(){
        self.countTimeLength = ConfigUtils.shared.valueRelaxTime
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
    
    func stopTimer(){
        countTimer?.invalidate()
        for d in self.delegates { d.onPause() }
    }

    func resetTimer(directPlay:Bool = true){
        stopTimer()
        countTimeLength = ConfigUtils.shared.valueRelaxTime
        for d in self.delegates { d.onReset() }
        if directPlay{ startTimer() }
    }
    
    func skipTimer(){
        for d in self.delegates { d.onFinish() }
    }
    
}
