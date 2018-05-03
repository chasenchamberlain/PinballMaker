//
//  ViewController.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/12/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {
    
    var glkView: GLKView!
    
    var model = Model()
    
    let trayAreaTouch: CGRect = CGRect(x: Int(UIScreen.main.bounds.width - 46), y: 64, width: 46, height: Int(UIScreen.main.bounds.height - 64))
    var tray: Tray!
    var playButton: PlayButton!
    var editButton: EditButton!
    var undoButton: UndoButton!
    var leftPaddle: LeftPaddle!
    var rightPaddle: RightPaddle!
    var plunger: Plunger!
    var ball: Ball!

    var baseComponents = [Sprite]()
    var components = [Sprite]()
    
    var hitboxesOfAddableComponents = [CGRect]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                self.preferredFramesPerSecond = 60
        
        glkView = self.view as! GLKView
        let context = EAGLContext(api: .openGLES2)
        glkView.context = context!
        EAGLContext.setCurrent(context)
        
        self.model = Model()
        self.tray = Tray()
        self.playButton = PlayButton()
        self.editButton = EditButton()
        self.undoButton = UndoButton()
        self.leftPaddle = LeftPaddle()
        self.rightPaddle = RightPaddle()
        self.ball = Ball()
        self.plunger = Plunger()
        debugDrawOfSorts(x: 2, y: 17, spr: leftPaddle)
        debugDrawOfSorts(x: 8, y: 17, spr: rightPaddle)
        setup()
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func trayLogic() {
        if(model.trayOut) // Tray is moving out or out
        {
            model.componentSelected = false
            if(self.tray.X > 0 ) // move it to the middle of the screen
            {
                self.tray.moveTrayInOrOut(direction: "out")
            }
            else if(!model.displayTray)
            {
                // draw the components to check from and trigger something to let the controller know they can select a component
                model.displayTray = true
                
                // function to put components on the tray
                self.drawComponentsOnTray()
            }
        }
        else // Tray is moving back
        {
            if(self.tray.X <= 0.8)
            {
                self.tray.moveTrayInOrOut(direction: "in")
            }
            if(model.displayTray)
            {
                self.undrawDrawComponentsOnTray()
                model.displayTray = false
            }
            else if(model.componentSelected && model.displayTray)
            {
                self.undrawDrawComponentsOnTray()
                model.displayTray = false
            }
        }
    }
    
    func update() {
        switchStateAndTextures()
        setupForPlayOrEdit()
        listenForFlagAnimationsAndUpdates()
        if(model.editState)
        {
            undoComponent()
            trayLogic()
        }
        else // Playing
        {
            trayLogic()
            self.tray.moveTrayInOrOut(direction: "in")
            resetTheBallAndFlipperTexture()
            
            if(!plunger.cycled)
            {
            }
            if(model.paddleLeftUp)
            {
                if(leftPaddle.rotationZ < 25)
                {
                    leftPaddle.rotationZ += 6
                }
            }
            else
            {
                if(leftPaddle.rotationZ > 0)
                {
                    leftPaddle.rotationZ -= 6
                }
            }
            
            if(model.paddleRightUp)
            {
                if(rightPaddle.rotationZ > -25)
                {
                    rightPaddle.rotationZ -= 6
                }
            }
            else
            {
                if(rightPaddle.rotationZ < 0)
                {
                    rightPaddle.rotationZ += 6
                }
            }
            checkBall(timeSinceLastDraw)
        }
    }
    
    func checkBall(_ dt: TimeInterval) {
        let updatedBallPosition = model.collisionCheck(posX: self.ball.positionX, posY: self.ball.positionY, dt: dt, leftFlip: (leftPaddle.positionX, leftPaddle.positionY, leftPaddle.rotationZ), rightFlip: (rightPaddle.positionX, rightPaddle.positionY, rightPaddle.rotationZ) )
        
        self.ball.positionX = updatedBallPosition.x
        self.ball.positionY = updatedBallPosition.y
    }

    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.5, 0.5, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        update()
        drawComponents()
    }
    
    // Draws all the components associated with the view.
    func drawComponents()
    {
        for comp in components
        {
            comp.draw()
        }
        for comp in baseComponents
        {
            comp.draw()
        }
    }
    
    // MARK: - Intial Setup
    // Setups up our GameScene with appropriate walls etc.
    func setup()
    {
        model.hitboxesOfStaticParts.append(playButton.hitbox)
        model.hitboxesOfStaticParts.append(editButton.hitbox)
        model.hitboxesOfStaticParts.append(undoButton.hitbox)
        model.hitboxesOfStaticParts.append(tray.hitbox)
        
        drawGrid()
        baseComponents.append(tray)
    }
    
    // Assists with switch the state and the textures of the play button and edit button
    fileprivate func switchStateAndTextures() {
        if(model.swapTextures)
        {
            self.playButton.switchTextures()
            self.editButton.switchTextures()
            model.swapTextures = false
        }
    }
    
    // Setups the view for either playing or editing
    private func setupForPlayOrEdit(){
        if(model.removeTray)
        {
            baseComponents.removeLast()
            components.append(ball)
            debugDrawOfSorts(x: model.gridX - 2, y: model.gridY - 3, spr: plunger)
            model.hitboxesOfStaticParts[2] = CGRect(x: 320, y: 160, width: 32, height: model.gameAreaHeight)
            model.removeTray = false
        }
        
        if(model.addTray)
        {
            self.tray = Tray()
            baseComponents.removeLast()
            components.removeLast()
            baseComponents.append(tray)
            model.addTray = false
        }
    }

    private func resetTheBallAndFlipperTexture()
    {
        if(model.reset)
        {
            let pos = model.openGLIt(11, 17)
            ball.positionX = pos.x
            ball.positionY = pos.y
            model.reset = false
        }
    }
    
    // Removes the last component, initiated by the model boolean switch values
    fileprivate func undoComponent() {
        // make sure to stop undos at a certain point.
        if(model.undoComponet)
        {
            if(!components.isEmpty)
            {
                components.removeLast()
            }
            model.undoComponet = false
        }
    }
    
    func listenForFlagAnimationsAndUpdates()
    {
        if(model.cycleFlagAnimations)
        {
            if(!model.flagIndexToAnimate.isEmpty)
            {
                let index = model.flagIndexToAnimate.first!
                let flag: Flag = components[index] as! Flag
                if(!flag.deleteMe)
                {
                    flag.nextTexture()
                }
                else
                {
                    components.remove(at: index)
                    model.hitboxesOfAddedComponents.remove(at: index)
                    let changeMe = model.gridCordinatesOfRecentlyAddedComponents[index]
                    model.gameGrid[changeMe[0]][changeMe[1]] = 7
                    model.gridCordinatesOfRecentlyAddedComponents.remove(at: index)
                    model.flagIndexToAnimate.removeFirst()
                    model.cycleFlagAnimations = false
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dummy = touches.first
        self.model.touchesBegan(touches, pixelTouch: (dummy?.location(in: glkView))!)
        if(model.editState)
        {
            if(model.componentSelected)
            {
                let compPosition = model.getComponentCalculations()
                
                if(compPosition.flooredX != 0 || compPosition.flooredY != 0)
                {
                    var component = Sprite()
                    switch model.componentValue{
                    case 0:
                        component = CircleBumper()
                    case 1:
                        component = TriangleBumper()
                    case 2:
                        component = Peg()
                    case 3:
                        component = Flag()
                    case 4:
                        component = TriangleBumperL()
                    default:
                        component = WallSprite()
                    }
                    component.setHitbox(x: compPosition.flooredX * 32, y: compPosition.flooredY * 32)
                    model.hitboxesOfAddedComponents.append(component.hitbox)
                    component.positionX = compPosition.gridX
                    component.positionY = compPosition.gridY
                    components.append(component)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesMoved(touches)
    }
    
    override func  touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dummy = touches.first
        self.model.touchesEnded(touches, pixelTouch: (dummy?.location(in: glkView))!)

    }
    
    fileprivate func debugDrawOfSorts(x: Int, y: Int, spr: Sprite) {
//        let component = WallSprite()
        spr.setQuadVertices()
        let i = Float(x * 32) // location of x tap
        let k = Float(y * 32) // location of y tap

        let w = Float(glkView.frame.size.width)
        let h = Float(glkView.frame.size.height)
        
        let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
        let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
        spr.positionX = gridX + 0.05
        spr.positionY = gridY + -0.05
        baseComponents.append(spr)
    }
    
    func drawComponentsOnTray()
    {
        var add: CGFloat = 4

        let textureFloatArray: [[Float]] = [
        [116, 0, 32, 32],
        [148, 0, 32, 32],
        [180, 0, 16, 32],
        [403, 1, 32, 29],
        [208, 0, 32, 32]
        ]
        for i in 0 ..< 5
        {
            let test = TrayComponent()
            test.hitbox = CGRect(x: 7 * 32 , y: add * 32, width: 96.0, height: 96.0)
            if(model.hitboxesOfTraySelections.count != 5)
            {
                model.hitboxesOfTraySelections.append(test.hitbox)
            }
            test.setTextureVertices(x: textureFloatArray[i][0], y: textureFloatArray[i][1], w: textureFloatArray[i][2], h: textureFloatArray[i][3])
            debugDrawOfSorts(x: 8, y: Int(add), spr: test)

            add += 3.0
        }
        

    }
    
    func undrawDrawComponentsOnTray()
    {
        for _ in 0 ..< 5
        {
            baseComponents.removeLast()
        }
    }
    
    func drawGrid()
    {
        for y in 0 ..< model.gameGrid.count
        {
            for x in 0 ..< model.gameGrid[y].count
            {
                if(model.gameGrid[y][x] == 5)
                {
                    let component = WallSprite()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)

                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0

                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 0)
                {
                    let component = CircleBumper()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 1)
                {
                    let component = TriangleBumper()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 2)
                {
                    let component = Peg()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 3)
                {
                    let component = Flag()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 4)
                {
                    let component = TriangleBumperL()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 8) // play button
                {
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0

                    playButton.positionX = gridX
                    playButton.positionY = gridY
                    baseComponents.append(playButton)
                }
                if(model.gameGrid[y][x] == 9) // edit button
                {
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0

                    editButton.positionX = gridX
                    editButton.positionY = gridY
                    baseComponents.append(editButton)
                }
                if(model.gameGrid[y][x] == 10) // undo button
                {
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0

                    undoButton.positionX = gridX
                    undoButton.positionY = gridY
                    baseComponents.append(undoButton)
                }
                // DEBUGGING PURPOSE, TO USE IT UNCOMMENT THE LAST LINE
                if(model.gameGrid[y][x] == 7 )//|| model.gameGrid[y][x] == 0)
                {
                    let component = WallSprite()
                    component.setTextureVertices(x: 627, y: 0, w: 32, h: 32)
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)

                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0

                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
//                    baseComponents.append(component)
                }
            }
        }
    }

    
}

