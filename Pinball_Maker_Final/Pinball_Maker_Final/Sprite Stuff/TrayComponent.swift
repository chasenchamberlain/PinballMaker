//
//  TrayComponent.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/24/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class TrayComponent: Sprite
{
    override init() {
        super.init()
        self.quad = [
            -1.0, -1.0, // BR
            1.0, 0.0, 1.0, 0.0, // color
            0.0, 1.0, // texture TL
            
            1.0, -1.0, // BL
            1.0, 0.0, 1.0, 0.0,
            1.0, 1.0, // texture TR
            
            -1.0, 1.0, // TR
            1.0, 0.0, 1.0, 0.0,
            0.0, 0.0, // texture BL
            
            1.0, 1.0, // TL
            1.0, 0.0, 1.0, 0.0,
            1.0, 0.0 // texture BR
        ]
        
        self.width = 64.0
        self.height = 64.0
        self.setQuadVertices()
        self.setTextureVertices(x: 627.0, y: 0, w: 32.0, h: 32.0)
        

        
    }
}
