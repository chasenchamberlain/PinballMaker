//
//  GameScreen.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/12/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class GameScreen: Sprite
{
    var gameArea: CGSize
    
    //    let leftPaddle: Sprite
    //    let rightPaddle: Sprite
    //
    //    let rightWall: Sprite
    //    let leftWall: Sprite
    //    let topWall: Sprite
    
//    var ball: Sprite
    
    var velocityX: Float = 10
    var velocityY: Float = 10
    
    // editing = false is play, editing = true is editing
    var editing: Bool = false
    override init() {
        let height: CGFloat = UIScreen.main.bounds.size.height - 64
        let width: CGFloat = UIScreen.main.bounds.size.width
        self.gameArea = CGSize(width: width, height: height)
        super.init()
        self.image = UIImage(named: "tech-background")!
        self.texture = try? GLKTextureLoader.texture(with: self.image.cgImage!, options: nil)
//        self.ball = WallSprite()
//        super.init(image: UIImage(named: "tech-background")!)
        
        self.positionX = 0.0
        self.positionY = 0.0
        
        self.quad = [
            -1.0, -1.0, // BR
            1.0, 0.0, 1.0, 0.0, // color
            0.0, 1.0, // texture TL
            
            1.0, -1.0, // BL
            1.0, 0.0, 1.0, 0.0,
            1.0, 1.0, // texture TR
            
            -1.0, 0.8, // TL
            1.0, 0.0, 1.0, 0.0,
            0.0, 0.0, // texture BL
            
            1.0, 0.8, // TR
            1.0, 0.0, 1.0, 0.0,
            1.0, 0.0 // texture BR
        ]
        
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
        
    }
}
