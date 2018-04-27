//
//  Tray.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/21/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Tray: Sprite {
    var X: Float
    override init() {
        self.X = 0.8
        
        super.init()
        
        self.quad = [
            0.8, -1.0, // BR
            1.0, 0.0, 1.0, 0.0, // color
            0.0, 1.0, // texture TL
            
            1.0, -1.0, // BL
            1.0, 0.0, 1.0, 0.0,
            1.0, 1.0, // texture TR
            
            0.8, 0.8, // TR
            1.0, 0.0, 1.0, 0.0,
            0.0, 0.0, // texture BL
            
            1.0, 0.8, // TL
            1.0, 0.0, 1.0, 0.0,
            1.0, 0.0 // texture BR
        ]
        self.width = 46.0
        self.height = Float(UIScreen.main.bounds.height - 64.0)
//        self.setQuadVertices()
        
        self.setTextureVertices(x: 627, y: 0, w: 32, h: 32)
        
        self.setHitbox(x: UIScreen.main.bounds.width - 46, y: 64)
    }
    
    // Moves the tray around.
    func moveTrayInOrOut(direction: String)
    {
        if(direction == "out")
        {
            self.X = self.X - 0.1
            self.quad[0] = self.X
            self.quad[16] = self.X
        }
        else
        {
            self.X = self.X + 0.1
            self.quad[0] = self.X
            self.quad[16] = self.X
        }
    }
    
    
    
}
