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
        self.width = 32.0
        self.height = 9.0
        self.setQuadVertices()
        
        self.setTextureVertices(x: 32, y: 23, w: 32, h: 9)
        
        self.vertices = verts
        print(" ") // helps readability
    }
    
    func cycleTextures()
    {
        switch texIndex
        {
        case 0:
            texIndex += 1
            self.height = textures[texIndex][3]
            self.setTextureVertices(x: textures[texIndex][0], y: textures[texIndex][1], w: textures[texIndex][2], h: textures[texIndex][3])
        case 1:
            texIndex += 1
            self.height = textures[texIndex][3]
            self.setTextureVertices(x: textures[texIndex][0], y: textures[texIndex][1], w: textures[texIndex][2], h: textures[texIndex][3])
            cycled = true
        case 2:
            texIndex = 0
            self.height = textures[texIndex][3]
            self.setTextureVertices(x: textures[texIndex][0], y: textures[texIndex][1], w: textures[texIndex][2], h: textures[texIndex][3])
            cycled = false
        default:
            texIndex = 0
        }
    }
}
