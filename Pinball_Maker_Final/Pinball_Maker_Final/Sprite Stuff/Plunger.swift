//
//  Plunger.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/28/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Plunger: Sprite{
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
        self.height = 9.0
        self.setQuadVertices()
        
        self.setTextureVertices(x: 32, y: 23, w: 28, h: 9)
        
        self.vertices = verts
        print(" ") // helps readability
    }
}
