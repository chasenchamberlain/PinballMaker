//
//  Model.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/15/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

// will have the glkview for cordinates, also snap map business
class Model
{
    let glkView: GLKView
//    var gameScene: GameScreen
    
    init(view: GLKView){
        glkView = view
    }
}

// controls all interactions between touches and collisions between the view controller nad the game view

