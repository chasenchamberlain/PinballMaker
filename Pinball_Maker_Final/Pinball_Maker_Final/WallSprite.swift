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
        
        self.positionX = 0.5
        self.positionY = -1.0
        
        var verts: [Float] = []
        verts.append(quad[0])
        verts.append(quad[1])
        
        verts.append(quad[8])
        verts.append(quad[9])
        
        verts.append(quad[16])
        verts.append(quad[17])
        
        verts.append(quad[24])
        verts.append(quad[25])
        
        self.vertices = verts
        
        //        self.height = self.
        
        print("\(self.height)")
        print("\(self.width)")
        print("\(self.boundingBoxWithModelViewMatrix(parenetModelViewMatrix: self.modelViewMatrix))")
        
        self.scaleY = 1
        self.scaleX = 1
        
        //        self.texture =
    }
}
