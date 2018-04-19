//
//  SquareSprite.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/15/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class WallSprite: Sprite
{
    init() {
        super.init(image: UIImage(named: "thermostat")!)
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
            1.0, 0.0 // texture
        ]
        
        let verts: [Float] = self.getPositionVertices()
        self.width = 170.0
        self.height = 296.0
    
        
        self.vertices = verts
        
        print("\(self.height)")
        print("\(self.width)")
        print("\(self.boundingBoxWithModelViewMatrix(parenetModelViewMatrix: self.modelViewMatrix))")
    }
}
