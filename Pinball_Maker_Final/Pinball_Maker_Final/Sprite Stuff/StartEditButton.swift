//
//  StartEditButton.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/19/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class StartEditButton: Sprite {
    
    override init(){
//        super.init(image: UIImage(named: "thermostat")!)
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
        
        let verts: [Float] = self.getPositionVertices()
        self.width = 64.0
        self.height = 64.0

        self.setQuadVertices()
        
        self.positionX = -0.85
        self.positionY = 0.9
        
        self.setTextureVertices(x: 355.0, y: 0.0, w: 16.0, h: 16.0)
        
        self.vertices = verts
    }
}
