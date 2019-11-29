//
//  RectangleView.swift
//  EyeSaver
//
//  Created by Marno on 9/14/19.
//  Copyright © 2019 Marno. All rights reserved.
//

import Cocoa

class RectangleView: NSVisualEffectView {

    override func awakeFromNib() {
        self.autoresizingMask = [.width, .height]
        self.blendingMode = .behindWindow
        self.state = .active
//        self.material = .toolTip
        self.material = .sidebar
    }
}
