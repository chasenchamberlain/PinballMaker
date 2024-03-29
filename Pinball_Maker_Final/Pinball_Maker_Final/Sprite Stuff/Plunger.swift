//
//  Plunger.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/28/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Plunger: Sprite{
    private var texIndex = 0
    
    var cycled = false
    
    private var textures: [[Float]] = [
    [32, 23, 28, 9],
    [60, 16, 28, 16],
    [88, 8, 28, 24]
    ]
    
    override init() {
        super.init()
        self.quad = [
            0.0, 0.0,
            1.0, 0.0, 1.0, 0.0, // color
            0.0, 1.0, // texture
            
            0.5, 0.0,
            1.0, 0.0, 1.0, 0.0,
            1.0, 1.0, // texture
            
            0.0, 0.5,
            1.0, 0.0, 1.0, 0.0,
            0.0, 0.0, // texture
            
            0.5, 0.5,
            1.0, 0.0, 1.0, 0.0,
            1.0, 0.0, // texture
        ]
        let verts: [Float] = self.getPositionVertices()
        self.width = 28.0
        self.height = 24.0
        self.setQuadVertices()
        
        self.setTextureVertices(x: 88, y: 8, w: 28, h: 24)
        
        self.vertices = verts
    }
}
