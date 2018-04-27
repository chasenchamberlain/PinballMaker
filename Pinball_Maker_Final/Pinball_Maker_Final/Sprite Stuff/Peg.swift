//
//  Peg.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/27/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Peg: Sprite{
    override init() {
        super.init()
        //        super.init(image: UIImage(named: "thermostat")!)
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
        self.width = 16.0
        self.height = 32.0
        self.setQuadVertices()
        
        self.setTextureVertices(x: 180, y: 0, w: 16, h: 32)
        
        self.vertices = verts
        print(" ") // helps readability
    }
}
