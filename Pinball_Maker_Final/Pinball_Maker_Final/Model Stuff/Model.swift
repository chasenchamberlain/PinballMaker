//
//  Model.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/15/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit
import Foundation

class Model
{
    // 2 Variable that represents the area of the game screen
    let gameAreaHeight: CGFloat = (UIScreen.main.bounds.height)
    let gameAreaWidth: CGFloat =  (UIScreen.main.bounds.width)
    
    // Grid dimensions
    var gridX: Int = 0
    var gridY: Int = 0
    
    // 2D array that represents the grid of where components are represented on the screen.
    var gameGrid = [[Int]]()
    
    // TODO: Variable for gravity
    
    // TODO: Variable for different objects forces
    
    // Boolean for if the tray is out or not
    var trayOut = false
    
    // Boolean for to display components on the tray or not
    var displayTray = false
    
    // Boolean for play or edit, we start in edit mode
    var editState = true
    
    // 0 - 4 is the selectable components from the tray, this value represents that
    var componentValue: Int = -1
    
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
    
    // Setup grid dimensions
    func setupGridDimensions(){
        self.gridX = Int(ceil(UIScreen.main.bounds.width / 32.0)) + 1
        self.gridY = Int(ceil(UIScreen.main.bounds.height / 32.0))
    }
    
    // Establish the starting game grid
    func setupTheGrid(){
        setupGridDimensions()
//        self.gameGrid = [[Int]](repeating: [Int](repeating: -1, count: self.gridX), count: self.gridY)
        

        var yRow = 0
        while(yRow < self.gridY)
        {
            var row: [Int] = [Int](repeating: -1, count: self.gridX)
            if(yRow == 1 )
            {
//                row = [Int](repeating: -1, count: self.gridX) // Button area, 2 rows worth.
                row[1] = 8
                row[3] = 9
                row[self.gridX - 3] = 10
            }
            else if(yRow == 2)
            {
                row = [Int](repeating: 0, count: self.gridX) // top wall
            }
            else if(yRow > 2)
            {
                row = [Int](repeating: 7, count: self.gridX)
                row[0] = 0 // Setting the left wall
                
                if(yRow == 3 || yRow == 4)
                {
                    row[self.gridX - 1] = 0
                }
                if(yRow > 4)
                {
                    row[self.gridX - 4] = 0
                    row[self.gridX - 2] = 0
                }
                
                if(yRow == self.gridY - 3)
                {
                    row[self.gridX - 2] = 1
                }
                
                if(yRow == self.gridY - 1)
                {
                    row[self.gridX - 1] = 0
                }
            }
            self.gameGrid.append(row)
            yRow = yRow + 1
        }
        
//        var yRow = 0
//        for x in 0 ..< gameGrid.count
//        {
//            for y in 0 ..< gameGrid[x].count
//            {
//                if ((yRow == 0 || yRow == 1) && y == 0)
//                {
//                    continue
//                }
//                if (yRow == 2 && y == 0)
//                {
//                    let array = [Int](repeating: 0, count: self.gridX)
//                    self.gameGrid[y] = array
//                    continue
//                }
//                if(x == 0)
//                {
//                    gameGrid[x][y] = 0
//                }
//            }
//            yRow = yRow + 1
//        }
        
    }
    
    func touchesBegan(_ touches: CGPoint){
    }
    func touchesMoved(_ touches: Set<UITouch>){
        
    }
    func touchesEnded(_ touches: Set<UITouch>){
        
    }
    
    
}
// will have the glkview for cordinates, also snap map business

// controls all interactions between touches and collisions between the view controller nad the game view

