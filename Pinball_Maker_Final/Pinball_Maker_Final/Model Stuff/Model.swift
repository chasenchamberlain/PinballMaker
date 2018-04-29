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
    
    // Velocity of the ball
    var velocityX: Float = 0.7
    var velocityY: Float = 0.0
    var ballRadius = 8
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
    var hitboxesOfTraySelections = [CGRect]()
    
    // Button hitboxes, try, and walls
    var hitboxesOfStaticParts = [CGRect]()
    
    // Hitboxes for any added components
    var hitboxesOfAddedComponents = [CGRect]()
    
    var hitboxLeftPaddleArea = CGRect()
    var hitboxRightPaddleArea = CGRect()
    
    // Grid cordinates of where all my components are placed
    var gridCordinatesOfRecentlyAddedComponents = [[Int]]()
    
    // Method to calculate touch location acording to game area
    func touchLocationToGameArea(_ touchLocation: CGPoint) -> CGPoint {
//        let ratio = (gameAreaHeight / gameAreaHeight)
        let x = touchLocation.x // ratio
        let y = (touchLocation.y) // ratio
        return CGPoint(x: x, y: y)
    }
    
    // Setup grid dimensions
    func setupGridDimensions(){
        self.gridX = Int(ceil(UIScreen.main.bounds.width / 32.0)) + 1
        self.gridY = Int(ceil(UIScreen.main.bounds.height / 32.0))
    }
    
    // Establish the starting game grid
    init(){
        setupGridDimensions()
//        self.gameGrid = [[Int]](repeating: [Int](repeating: -1, count: self.gridX), count: self.gridY)
        
        self.hitboxLeftPaddleArea = CGRect(x: 0, y: self.gameAreaHeight/2, width: self.gameAreaWidth/2, height: self.gameAreaHeight/2)
        self.hitboxRightPaddleArea = CGRect(x: self.gameAreaWidth/2, y: self.gameAreaHeight/2, width: self.gameAreaWidth/2, height: self.gameAreaHeight/2)
        let leftWall = CGRect(x: 0, y: 64, width: 32, height: self.gameAreaHeight - 64)
        let topWall = CGRect(x: 0, y: 64, width: self.gameAreaWidth, height: 32)
        let plungerWall = CGRect(x: 320, y: 160, width: 32, height: 507)
        
        hitboxesOfStaticParts.append(topWall)
        hitboxesOfStaticParts.append(leftWall)
        hitboxesOfStaticParts.append(plungerWall)
        // order of adding is critical, top, right, left, plunger

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

        if (self.hitboxesOfStaticParts[3].contains(pixelTouch) || self.hitboxesOfStaticParts[4].contains(pixelTouch)) // play or edit button
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
            if(self.hitboxesOfStaticParts[6].contains(pixelTouch)) // tray tap
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
            
            
            if(self.hitboxesOfStaticParts[5].contains(pixelTouch)) // undo button
            {
                self.undoComponet = true
                if(!gridCordinatesOfRecentlyAddedComponents.isEmpty)
                {
                    let toDestroy = gridCordinatesOfRecentlyAddedComponents.removeLast()
                    self.gameGrid[toDestroy[0]][toDestroy[1]] = 7
                }
                if(!hitboxesOfAddedComponents.isEmpty)
                {
                    hitboxesOfAddedComponents.removeLast()
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
                for i in 0 ..< self.hitboxesOfTraySelections.count
                {
                    if (self.hitboxesOfTraySelections[i].contains(pixelTouch))
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
    
    func openGLIt(_ x: Float, _ y: Float) -> (x: Float, y: Float)
    {
        let i = Float(x * 32) // location of x tap
        let k = Float(y * 32) // location of y tap
        let w = Float(gameAreaWidth)
        let h = Float(gameAreaHeight)
        var glX = (2.0 * i + 1.0) / w - 1.0 //(2.0 * i) / w - 1.0
        var glY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
        glX = glX + 0.05
        glY = glY + -0.05
        
        return (glX, glY)
    }
    
    // Calculates all collision physic stuff and returns it to the view to update accordingly
    func collisionCheck(posX: Float, posY: Float, dt: TimeInterval) -> (x: Float, y: Float){
        // move the ball position
        var ballX = posX + self.velocityX * Float(dt)
        var ballY = posY + self.velocityY * Float(dt)
        
        let dumbX = gameAreaWidth * ((CGFloat(ballX - 0.05) * gameAreaWidth)/gameAreaWidth)
        let dumbY = gameAreaHeight * -((CGFloat(ballY + 0.05) * gameAreaHeight)/gameAreaHeight)
        
        let xPix: CGFloat = (dumbX + gameAreaWidth - 1)/2
        let yPix: CGFloat = (dumbY + gameAreaHeight + 1)/2


        let ballHitbox: CGRect = CGRect(x: xPix, y: yPix, width: 16, height: 16)
        
        let xG: Int = Int(round(xPix/32))
        let yG: Int = Int(round(yPix/32))
        
        // check for if it was a plunger shot so it will shoot it to the left
        
        // check for collisions on all hitboxes.
        for i in 0 ..< 3
        {
            let checkMe = self.hitboxesOfStaticParts[i]
            if(ballHitbox.intersects(checkMe))
            {
                print("COLLISIONS")
                print("The glY \(ballY), The glX \(ballX)")
                print("")
                print("The Y pixel \(xPix), The X pixel \(yPix)")
                print("")
                switch i
                {
                case 0:
                    self.velocityY *= -1
                case 1:
                    self.velocityX *= -1
                case 2:
                    self.velocityX *= -1
                default:
                    print("default")
                }
            }
        }
        
        for i in 0 ..< self.hitboxesOfAddedComponents.count
        {
            let checkMe = self.hitboxesOfAddedComponents[i]
            let gridLocation = self.gridCordinatesOfRecentlyAddedComponents[i]
            let gridValue = gameGrid[gridLocation[0]][gridLocation[1]]
            if(ballHitbox.intersects(checkMe))
            {
                print("COLLISIONS")
                print("The glY \(ballY), The glX \(ballX)")
                print("")
                print("The Y pixel \(xPix), The X pixel \(yPix)")
                print("")
                switch gridValue
                {
                case 0: // Circle bumper
                    print("Circle bumper")
                    self.velocityX *= -1
                case 1: // Triangle bumper L
                    print("Triangle bumper L")
                    self.velocityY *= -1
                case 2: // Peg
                    print("Peg")
                    self.velocityX *= -1
                case 3: // Flag
                    print("Flag")
                case 4: // Triangle bumper R
                    print("Triangle bumper R")
                    self.velocityX *= -1
                    self.velocityY *= -1

                default:
                    print("Default wall")
                }
            }
        }
        
        // check for out of bounds
        if(yPix >= gameAreaHeight)
        {
            // reset the ball
        }
        // respond if necessary to out of bounds or collisions

//        ballX = posX + self.velocityX * Float(dt)
//        ballY = posY + self.velocityY * Float(dt)
        
        // send the info back and draw
        return(ballX, ballY)
    }
}

struct Vector2D
{
    
}
// controls all interactions between touches and collisions between the view controller nad the game view

