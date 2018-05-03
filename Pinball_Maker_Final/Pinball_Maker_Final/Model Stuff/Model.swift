//
//  Model.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/15/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit
import Foundation

class Model : Codable
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
    var ballRadius: CGFloat = 8
    var bumperCircleRadius = 16
    
    let flipperTipRadiusX: CGFloat = 5.0
    let flipperTipRadiusY: CGFloat = 20.0
    
    let flipperBaseRadiusX: CGFloat = 25.0
    let flipperBaseRadiusY: CGFloat = 13.0
    
    var bx: Float = 0
    var by: Float = 0
    
    // Variable for gravity
    var gravity: Float = 0
    
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
    
    // Boolean for reset
    var reset = false
    
    // Boolean for launching the ball
    var launchBall = false
    
    // Boolean for playing game
    var playing = false
    
    // Boolean for knowing if we need to make the hitbox for the left wall larger
    var makePlungerLarger = false
    
    // Flag animation stuff
    var cycleFlagAnimations = false
    var cycleMultipleFlags = false
    var flagIndexToAnimate: [Int] = []
    
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
        let leftWall = CGRect(x: -5, y: 64, width: 32, height: self.gameAreaHeight)
        let topWall = CGRect(x: 0, y: 64, width: self.gameAreaWidth, height: 32)
        let plungerWall = CGRect(x: 325, y: 160, width: 32, height: self.gameAreaHeight)
        
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
                row = [Int](repeating: 5, count: self.gridX) // top wall
            }
            else if(yRow > 2 && yRow < gridY - 1)
            {
                row = [Int](repeating: 7, count: self.gridX)
                row[0] = 5 // Setting the left wall
                row[self.gridX - 1] = 5
                row[self.gridX - 2] = -1
                
                if(yRow == 3 || yRow == 4)
                {
                    row[self.gridX - 3] = -1
                }

                
//                if(yRow == 3 || yRow == 4)
//                {
//                    row[self.gridX - 1] = 0
//                }
                if(yRow > 4)
                {
                    row[self.gridX - 3] = 5
                    row[self.gridX - 1] = 5
                }
                
                if(yRow == self.gridY - 2)
                {
                    row[self.gridX - 2] = 5
                }
                
//                if(yRow == self.gridY - 1)
//                {
//                    row[self.gridX - 1] = 0
//                }
                if(yRow == self.gridY - 4)
                {
                    row[2] = -1
                    row[3] = -1
                    row[4] = -1
                    row[5] = -1
                    row[6] = -1
                    row[7] = -1
                    row[8] = -1
                }
                if(yRow == self.gridY - 5)
                {
//                    row[2] = -1
                    row[3] = -1
                    row[4] = -1
//                    row[5] = -1
                    row[6] = -1
                    row[7] = -1
                }
            }
            self.gameGrid.append(row)
            yRow = yRow + 1
        }
    }

    
    func touchesBegan(_ touches: Set<UITouch>, pixelTouch: CGPoint){
        if (self.hitboxesOfStaticParts[3].contains(pixelTouch) || self.hitboxesOfStaticParts[4].contains(pixelTouch)) // play or edit button
        {
            if(self.editState)
            {
                self.editState = false
                self.removeTray = true
                self.reset = true
                self.playing = false
                self.trayOut = false
                gravity = 0
            }
            else
            {
                self.editState = true
                self.addTray = true
                self.launchBall = false
            }
            swapTextures = true
            velocityY = 0.7
            velocityX = 0.0
        }

        if(self.editState) // Handles all editing state logic.
        {
            // This is the tray sliding in and out stuff.
            if(self.hitboxesOfStaticParts[6].contains(pixelTouch)) // tray tap
            {
                if(self.trayOut)
                {
                    self.trayOut = false
                }
                else
                {
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
            if(self.componentSelected)
            {
                self.flooredX = round(pixelTouch.x/32)
                self.flooredY = round(pixelTouch.y/32)
            }
            else // Pick the compoent to be placed
            {
                for i in 0 ..< self.hitboxesOfTraySelections.count
                {
                    if (self.hitboxesOfTraySelections[i].contains(pixelTouch))
                    {
                        self.componentSelected = true
                        self.componentValue = i
                    }
                }
            }
        }
        else // play mode time to shoot balls around
        {
            if(self.hitboxLeftPaddleArea.contains(pixelTouch))
            {
                self.paddleLeftUp = true
            }
            
            if(self.hitboxRightPaddleArea.contains(pixelTouch))
            {
                self.paddleRightUp = true
                if(!launchBall && !playing)
                {
                    launchBall = true
                    playing = true
                    makePlungerLarger = true
                }
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>){}
    func touchesEnded(_ touches: Set<UITouch>, pixelTouch: CGPoint){
        if(!self.editState)
        {
            if(self.hitboxLeftPaddleArea.contains(pixelTouch))
            {
                self.paddleLeftUp = false
            }
            
            if(self.hitboxRightPaddleArea.contains(pixelTouch))
            {
                self.paddleRightUp = false
            }
        }
    }
    
    func getComponentCalculations() -> (gridX: Float, gridY: Float, flooredX: CGFloat, flooredY: CGFloat){
        
        if(self.gameGrid[Int(flooredY)][Int(flooredX)] == 7)
        {

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
    fileprivate func checkForAnyCollision(_ leftBase: CGPoint, _ centerCircle: CGPoint, _ leftFlip: (x: Float, y: Float, z: Float), _ ballX: inout Float, _ posX: Float, _ dt: TimeInterval, _ ballY: inout Float, _ leftTip: CGPoint, _ posY: Float, _ rightBase: CGPoint, _ rightTip: CGPoint){
        // gravity
        
        if(circleCollision(flipperPortion: leftBase, ball: centerCircle, baseFlipper: true))
        {
            self.velocityY = (self.velocityY * -1) + (leftFlip.z / 1000)
            ballX = posX + self.velocityX * Float(dt)
            let newPosY = openGLIt(Float(round(leftBase.x) / 32 ), Float((round(leftBase.y) - (flipperBaseRadiusY + 10)) / 32))
            ballY = newPosY.y + self.velocityY * Float(dt)
        }
        else if(circleCollision(flipperPortion: leftTip, ball: centerCircle, baseFlipper: false))
        {
            self.velocityY = (self.velocityY * -1) + (leftFlip.z / 100)
            ballX = posX + self.velocityX * Float(dt)
            ballY = posY + self.velocityY * Float(dt)
        }
        else if(circleCollision(flipperPortion: rightBase, ball: centerCircle, baseFlipper: true))
        {
            self.velocityY = (self.velocityY * -1) + (leftFlip.z / 1000)
            ballX = posX + self.velocityX * Float(dt)
            ballY = posY + self.velocityY * Float(dt)
        }
        else if(circleCollision(flipperPortion: rightTip, ball: centerCircle, baseFlipper: false))
        {
            self.velocityY = (self.velocityY * -1) + (leftFlip.z / 100)
            ballX = posX + self.velocityX * Float(dt)
            ballY = posY + self.velocityY * Float(dt)
        }
        else
        {
            // check for collisions on all hitboxes.
            for i in 0 ..< 3
            {
                let checkMe = self.hitboxesOfStaticParts[i]
                if(intersects(circleCenter: centerCircle, rect: checkMe))
                {
                    switch i
                    {
                    case 0:
                        self.velocityY *= -1
                        let newPosY = openGLIt(0, Float(checkMe.origin.y + 32) / 32)
                        ballY = newPosY.y + velocityY * Float(dt)
                    case 1:
                        self.velocityX *= -1
                        let newPosX = openGLIt(Float(checkMe.origin.x + 32) / 32, 0)
                        ballX = newPosX.x + velocityX * Float(dt)
                        
                    case 2:
                        self.velocityX *= -1
                        let newPosX = openGLIt(Float(checkMe.origin.x - 32) / 32, 0)
                        ballX = newPosX.x + velocityX * Float(dt)
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
                if(intersects(circleCenter: centerCircle, rect: checkMe))
                {

                    switch gridValue
                    {
                    case 0: // Circle bumper
                        self.velocityX *= -1
                        self.velocityY *= -1
                    case 1: // Triangle bumper L
                        self.velocityY *= -1
                    case 2: // Peg
                        self.velocityX *= -1
                        self.velocityY *= -1
                    case 3: // Flag
                        // tell the view controller its time to cycle through textures
                        
                        if(!flagIndexToAnimate.isEmpty)
                        {
                            cycleMultipleFlags = true
                        }
                        else
                        {
                            cycleMultipleFlags = false
                        }
                        
                        flagIndexToAnimate.append(self.hitboxesOfAddedComponents.index(of: checkMe)!)
                        cycleFlagAnimations = true
                        
                        self.velocityX *= -1
                        self.velocityY *= -1
                    case 4: // Triangle bumper R
                        self.velocityY *= -1
                    default:
                        print("Default wall")
                    }
                }
            }
        }
    }
    
    // Does collision stuff
    func collisionCheck(posX: Float, posY: Float, dt: TimeInterval, leftFlip: (x: Float, y: Float, z: Float), rightFlip: (x: Float, y: Float, z: Float)) -> (x: Float, y: Float){
        // move the ball position
        if(playing)
        {
            var ballX = posX + self.velocityX * Float(dt)
            var ballY = posY + self.velocityY * Float(dt)
            
            var centerCircle = returnPixelLocationFromGL(x: CGFloat(ballX), y: CGFloat(ballY))
            centerCircle = CGPoint(x: centerCircle.x + ballRadius, y: centerCircle.y + ballRadius)
            
            let leftFlipperPixelLocation = returnPixelLocationFromGL(x: CGFloat(leftFlip.x), y: CGFloat(leftFlip.y))
            let rightFlipperPixelLocation = returnPixelLocationFromGL(x: CGFloat(rightFlip.x), y: CGFloat(rightFlip.y))
            
            let leftTip: CGPoint = CGPoint(x: (leftFlipperPixelLocation.x + 60 ) , y: (leftFlipperPixelLocation.y - CGFloat(leftFlip.z)))
            let leftBase: CGPoint = CGPoint(x: leftFlipperPixelLocation.x + 25, y:leftFlipperPixelLocation.y - CGFloat(leftFlip.z / 3 ))
            
            let rightTip: CGPoint = CGPoint(x: rightFlipperPixelLocation.x - 60, y: rightFlipperPixelLocation.y - CGFloat(rightFlip.z))
            let rightBase: CGPoint = CGPoint(x: rightFlipperPixelLocation.x - 25, y: rightFlipperPixelLocation.y - CGFloat(leftFlip.z / 3))

            if(centerCircle.x < 300 && makePlungerLarger)
            {
                hitboxesOfStaticParts[2] = CGRect(x: 320, y: 64, width: 32, height: self.gameAreaHeight)
                makePlungerLarger = false
            }
            if(centerCircle.y <= 128 && launchBall)
            {
                velocityY = 0.0
                velocityX = -0.8
                launchBall = false
                gravity = -0.008

            }
            else
            {
                checkForAnyCollision(leftBase, centerCircle, leftFlip, &ballX, posX, dt, &ballY, leftTip, posY, rightBase, rightTip)
                
                self.velocityY += gravity
                if(centerCircle.y >= gameAreaHeight || centerCircle.x <= 0)
                {
                    reset = true
                    playing = false
                    launchBall = false
                    velocityX = 0.0
                    velocityY = 0.7
                    hitboxesOfStaticParts[2] = CGRect(x: 320, y: 160, width: 32, height: self.gameAreaHeight)
                    gravity = 0
                }
            }
            return (ballX, ballY)
        }
        else
        {
            return (posX, posY)
        }
    }
    
    // Collision detection for flippers and balls.
    func circleCollision (flipperPortion: CGPoint, ball: CGPoint, baseFlipper: Bool ) -> Bool
    {
        if(baseFlipper)
        {
            let dx = ball.x - flipperPortion.x
            let dy = ball.y - flipperPortion.y
            let radii = flipperBaseRadiusX + ballRadius
            if( (dx * dx) + (dy * dy) < radii * radii)
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            let dx = ball.x - flipperPortion.x
            let dy = ball.y - flipperPortion.y
            let radii = flipperTipRadiusX + ballRadius
            if( (dx * dx) + (dy * dy) < radii * radii)
            {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    func intersects(circleCenter: CGPoint, rect: CGRect) -> Bool
    {
//        circleDistance.x = abs(circle.x - (rect.x + rect.width/2))
//        let circleDistanceX = abs(circleCenter.x - (rect.minX + rect.width/2))
//        let circleDistanceY = abs(circleCenter.y - rect.minY)
//
//        if(circleDistanceX > (rect.width/2 + ballRadius)) { return false}
//        if(circleDistanceY > (rect.height/2 + ballRadius)) { return false}
//
//        if(circleDistanceX <= (rect.width/2)) {return true}
//        if(circleDistanceY <= (rect.height/2)) {return true}
//
//        let cornerCaseSqrRoot = (circleDistanceX - pow(rect.width/2,2) + circleDistanceY - pow(rect.height/2, 2))
//
//        return (cornerCaseSqrRoot <= pow(ballRadius, 2))
        
        let DeltaX = circleCenter.x - max(rect.minX, min(circleCenter.x, rect.origin.x + rect.width))
        let DeltaY = circleCenter.y - max(rect.minY, min(circleCenter.y, rect.origin.y + rect.height))
        return (DeltaX * DeltaX + DeltaY * DeltaY) < (ballRadius * ballRadius);
    }
    
    func returnPixelLocationFromGL(x: CGFloat, y: CGFloat) -> CGPoint
    {
        let dumbX = gameAreaWidth * ((x - 0.05) * gameAreaWidth)/gameAreaWidth
        let dumbY = gameAreaHeight * -((y + 0.05) * gameAreaHeight)/gameAreaHeight
        
        let xPix: CGFloat = (dumbX + gameAreaWidth - 1)/2
        let yPix: CGFloat = (dumbY + gameAreaHeight + 1)/2
        
        let centerCircle: CGPoint = CGPoint(x: xPix, y: yPix)
        return centerCircle
    }
    
    // Save the data to json
    func saveData(){
        let jsonData = try? JSONEncoder().encode(self)
        
        let urlDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let directory: URL = (urlDirectory?.appendingPathComponent("pinball.json"))!
        
        try! jsonData?.write(to: directory)
    }

    // Load the date from json
    func loadData(){
        var newModel = Model()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = path?.appendingPathComponent("pinball.json")

        if let jsonData = FileManager.default.contents(atPath: (url?.path)!)
        {
            do
            {
                let decodedObj = try? JSONDecoder().decode(Model.self, from: jsonData)
                newModel = decodedObj ?? Model()
            }
        }
        
        self.gameGrid = newModel.gameGrid
    }
}

