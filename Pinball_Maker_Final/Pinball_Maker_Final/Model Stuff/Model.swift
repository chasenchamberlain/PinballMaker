//
//  Model.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/15/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Model
{
    // TODO: 2 Variable that represents the area of the game screen
    let gameAreaHeight: CGFloat = (UIScreen.main.bounds.height)
    let gameAreaWidth: CGFloat =  (UIScreen.main.bounds.width)
    
    // TODO: Variable for gravity
    
    // TODO: Variable for different objects forces
    
    // Boolean for if the tray is out or not
    var trayOut = false
    
    // Boolean for play or edit, we start in edit mode
    var editState = true
    
    // Boolean to show a user selected a component
    var componentSelected = false
    
    // Method to calculate touch location acording to game area
    func touchLocationToGameArea(_ touchLocation: CGPoint) -> CGPoint {
//        let ratio = (gameAreaHeight / gameAreaHeight)
        let x = touchLocation.x // ratio
        let y = (touchLocation.y) // ratio
        return CGPoint(x: x, y: y)
        
    }
    // TODO: Method to assit in pivoting the paddle
    
    // TODO: Method to update sprite accoring to its position acording to physics etc
    
    // TODO: Maybe same method as above, but a method for updating hitbox
    
    // TODO: Large logic method for checking hitbox locations in regards to the ball
    
    // TODO: Method to set up scene for playing/after losses this happens also
    
    // TODO: Method to set up scene for editing
    
    // TODO: Method to slide a tray in and out
    
    // TODO: fucking snapmap?!?!
    
    func touchesBegan(_ touches: CGPoint){
        print("Touch location in game area: \(touchLocationToGameArea(touches))")
    }
    func touchesMoved(_ touches: Set<UITouch>){
        
    }
    func touchesEnded(_ touches: Set<UITouch>){
        
    }
    
    
}
// will have the glkview for cordinates, also snap map business

// controls all interactions between touches and collisions between the view controller nad the game view

