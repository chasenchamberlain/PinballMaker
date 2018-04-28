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
    
    private var flooredX: CGFloat = 0
    private var flooredY: CGFloat = 0
    
    // 2D array that represents the grid of where components are represented on the screen.
    var gameGrid = [[Int]]()
    
    // TODO: Variable for gravity
    
    // TODO: Variable for different objects forces
    
    // Boolean switch for if the tray is out or not
    var trayOut = false
    
    // Boolean switch for to display components on the tray or not
    var displayTray = false
    
    // Boolean switch to remove the tray
    var removeTray = false
    
    // Boolean switch add the tray
    var addTray = false
    
    // Boolean switch for play or edit, we start in edit mode
    var editState = true
    
    // Boolean switch for switching textures for the view controller
    var swapTextures = false
    
    // Boolean switch for undoing a placed component
    var undoComponet = false
    
    // Boolean switch for left paddle movement up
    var paddleLeftUp = false
    
    // Boolean switch for right paddle movement up
    var paddleRightUp = false
    
    // 0 - 4 is the selectable components from the tray, this value represents that
    var componentValue: Int = -1
    
    // Boolean switch to show a user selected a component
    var componentSelected = false
    
    // Hitboxes for selectable components
    var hitboxesOfAddableComponents = [CGRect]()
    
    // Button hitboxes
    var hitboxesOfStaticParts = [CGRect]()
    
    var hitboxLeftPaddleArea = CGRect()
    var hitboxRightPaddleArea = CGRect()
    
    var gridCordinatesOfRecentlyAddedComponents = [[Int]]()
    
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
        
        self.hitboxLeftPaddleArea = CGRect(x: 0, y: self.gameAreaHeight/2, width: self.gameAreaWidth/2, height: self.gameAreaHeight/2)
        self.hitboxRightPaddleArea = CGRect(x: self.gameAreaWidth/2, y: self.gameAreaHeight/2, width: self.gameAreaWidth/2, height: self.gameAreaHeight/2)

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
            else if(yRow > 2 && yRow < gridY - 1)
            {
                row = [Int](repeating: 7, count: self.gridX)
                row[0] = 0 // Setting the left wall
                row[self.gridX - 1] = 0
                
                
//                if(yRow == 3 || yRow == 4)
//                {
//                    row[self.gridX - 1] = 0
//                }
                if(yRow > 4)
                {
                    row[self.gridX - 3] = 0
                    
                    row[self.gridX - 1] = 0
                }
                
                if(yRow == self.gridY - 2)
                {
                    row[self.gridX - 2] = 0
                }
                
//                if(yRow == self.gridY - 1)
//                {
//                    row[self.gridX - 1] = 0
//                }
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

    
    func touchesBegan(_ touches: Set<UITouch>, pixelTouch: CGPoint){

        if (self.hitboxesOfStaticParts[0].contains(pixelTouch) || self.hitboxesOfStaticParts[1].contains(pixelTouch)) // play or edit button
        {
            if(self.editState)
            {
                self.editState = false
                self.removeTray = true
            }
            else
            {
                self.editState = true
                self.addTray = true
            }
            swapTextures = true
        }

        if(self.editState) // Handles all editing state logic.
        {
            // Check if the area is already populated with a component, if it is don't put anything there.
            print("X in Grid before round: \((pixelTouch.x/32.0))")
            print("Y in Grid before round: \((pixelTouch.y/32.0))")
            
            // This is the tray sliding in and out stuff.
            if(self.hitboxesOfStaticParts[3].contains(pixelTouch)) // tray tap
            {
                if(self.trayOut)
                {
                    self.trayOut = false
                }
                else
                {
                    print("TRAY TOUCHED")
                    self.trayOut = true
                }
            }
            else if(self.trayOut)
            {
                self.trayOut = false
            }
            
            
            if(self.hitboxesOfStaticParts[2].contains(pixelTouch)) // undo button
            {
                self.undoComponet = true
                if(!gridCordinatesOfRecentlyAddedComponents.isEmpty)
                {
                    let toDestroy = gridCordinatesOfRecentlyAddedComponents.removeLast()
                    self.gameGrid[toDestroy[0]][toDestroy[1]] = 7
                }
            }
            
            // Place the component that was selected
            //            model.componentSelected = true // DEBUG
            if(self.componentSelected)
            {
                print("SET THE FLOORS")
                print("\(pixelTouch)")
                self.flooredX = round(pixelTouch.x/32)
                self.flooredY = round(pixelTouch.y/32)
                print("")
                    // END -- DEBUG PORTION
            }
            else // Pick the compoent to be placed
            {
                for i in 0 ..< self.hitboxesOfAddableComponents.count
                {
                    if (self.hitboxesOfAddableComponents[i].contains(pixelTouch))
                    {
                        self.componentSelected = true
                        print("Tapped on item at index: \(i)")
                        self.componentValue = i
                    }
                }
            }
        }
        else // play mode time to shoot balls around
        {
            print("PLAY TIME BOOOOI")
            
            if(self.hitboxLeftPaddleArea.contains(pixelTouch))
            {
                print("Tap left")
                self.paddleLeftUp = true
            }
            
            if(self.hitboxRightPaddleArea.contains(pixelTouch))
            {
                print("Tap right")
                self.paddleRightUp = true

            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>){}
    func touchesEnded(_ touches: Set<UITouch>, pixelTouch: CGPoint){
        if(!self.editState)
        {
            if(self.hitboxLeftPaddleArea.contains(pixelTouch))
            {
                print("Tap left")
                self.paddleLeftUp = false
            }
            
            if(self.hitboxRightPaddleArea.contains(pixelTouch))
            {
                print("Tap right")
                self.paddleRightUp = false
            }
        }
    }
    
    func getComponentCalculations() -> (gridX: Float, gridY: Float, flooredX: CGFloat, flooredY: CGFloat){
        
        if(self.gameGrid[Int(flooredY)][Int(flooredX)] == 7)
        {
            print("--- DRAWING A NEW COMPONENT ---")
            print(" ")
            let gridLocation: [Int] = [Int(flooredY), Int(flooredX)]
            
            let i = Float(self.flooredX * 32) // location of x tap
            let k = Float(self.flooredY * 32) // location of y tap
            let w = Float(UIScreen.main.bounds.width)
            let h = Float(UIScreen.main.bounds.height)
            var glX = (2.0 * i + 1.0) / w - 1.0 //(2.0 * i) / w - 1.0
            var glY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
            glX = glX + 0.05
            glY = glY + -0.05
            self.gameGrid[Int(flooredY)][Int(flooredX)] = self.componentValue
            self.gridCordinatesOfRecentlyAddedComponents.append(gridLocation)
            return (glX, glY, self.flooredX, self.flooredY)
        }
        return (0, 0, 0, 0)
    }
    
}

// controls all interactions between touches and collisions between the view controller nad the game view

