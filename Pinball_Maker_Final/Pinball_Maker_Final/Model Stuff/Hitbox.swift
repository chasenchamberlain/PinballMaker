//
//  Hitbox.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/18/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import Foundation

// Simple class to help me know if any collisions occur.
class Hitbox {
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    
    init(w: Float, h: Float, x: Float, y: Float) {
        self.width = w
        self.height = h
        self.x = x
        self.y = y
    }
}
