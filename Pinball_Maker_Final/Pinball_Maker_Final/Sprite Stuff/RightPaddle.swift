//
//  RightPaddle.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/27/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class RightPaddle: Sprite{
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
        self.width = 78.0
        self.height = 27.0
        self.setQuadVertices()
        self.positionX = 0.0
        self.positionY = 0.0
        self.setTextureVertices(x: 277, y: 3, w: 78, h: 27)
        
        self.vertices = verts
        print(" ") // helps readability
    }
}
