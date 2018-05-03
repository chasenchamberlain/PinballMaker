//
//  UndoButton.swift
//  Pinball_Maker_Final
//
//  Created by Chasen Chamberlain on 4/19/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class UndoButton: Sprite {
    
    var green: Bool = true
    
    override init(){
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
        
        self.positionX = 0.83
        self.positionY = 0.9
        
        self.setTextureVertices(x: 371.0, y: 16.0, w: 16.0, h: 16.0)
        
        self.vertices = verts
        
        self.setHitbox(x: 288, y: 0)
    }
    
    func switchTextures(){
        if(green)
        {
            self.setTextureVertices(x: 387.0, y: 0.0, w: 16.0, h: 16.0)
            green = false
        }
        else
        {
            self.setTextureVertices(x: 387.0, y: 16.0, w: 16.0, h: 16.0)
            green = true
        }
    }
}
