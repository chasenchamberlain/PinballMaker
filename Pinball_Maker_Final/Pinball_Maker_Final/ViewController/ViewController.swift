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
    
    //    private var translateX: Float = 0.0
    //    private var translateY: Float = 0.0
    //    private var time: Float = 0.0
    
    private var model: Model!
    
    let trayAreaTouch: CGRect = CGRect(x: Int(UIScreen.main.bounds.width - 46), y: 64, width: 46, height: Int(UIScreen.main.bounds.height - 64))
    var tray: Tray!
    var playButton: PlayButton!
    var editButton: EditButton!
    var undoButton: UndoButton!
    var leftPaddle: LeftPaddle!
    var rightPaddle: RightPaddle!
    var ball: Ball!

    var baseComponents = [Sprite]()
    var components = [Sprite]()
    
    var hitboxesOfAddableComponents = [CGRect]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.preferredFramesPerSecond = 60
        
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
        debugDrawOfSorts(x: 2, y: 17, spr: leftPaddle)
        debugDrawOfSorts(x: 8, y: 17, spr: rightPaddle)
        setup()
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        print("2D ARRAY DIMENSIONS --> W:\(glkView.frame.size.width/32) H:\(glkView.frame.size.height/32)")

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        switchStateAndTextures()
        setupForPlayOrEdit()
        if(model.editState)
        {
            undoComponent()
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
        else // Playing
        {
            checkBall(timeSinceLastDraw)
            if(model.paddleLeftUp)
            {
                if(leftPaddle.rotationZ < 25)
                {
                    leftPaddle.rotationZ += 5
                }
            }
            else
            {
                if(leftPaddle.rotationZ > 0)
                {
                    leftPaddle.rotationZ -= 5
                }
            }
            
            if(model.paddleRightUp)
            {
                if(rightPaddle.rotationZ > -25)
                {
                    rightPaddle.rotationZ -= 5
                }
            }
            else
            {
                if(rightPaddle.rotationZ < 0)
                {
                    rightPaddle.rotationZ += 5
                }
            }
        }
    }
    
    func checkBall(_ dt: TimeInterval) {
        let updatedBallPosition = model.collisionCheck(posX: self.ball.positionX, posY: self.ball.positionY, dt: dt)
        
        self.ball.positionX = updatedBallPosition.x
        self.ball.positionY = updatedBallPosition.y
        print("The ball Y APARENTLY: \(ball.positionY)")
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
        for comp in baseComponents
        {
            comp.draw()
        }
        for comp in components
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
        let gameScreenBackground = GameScreen()
//        let rightWall =  WallSprite()
//        components.append(gameScreenBackground)

        
//        components.append(gameScreenBackgroundFloat(UIScreen.main.bounds.height))
//        components.append(rightWall)
        
        debugDrawGrid()
        baseComponents.append(tray)

//        components.append(playButton)
//        components.append(editButton)
//        components.append(undoButton)
        if(model.editState)
        {
            //components.append(tray)
        }
    }
    
    
    // TODO:  Method to set quad coridnates for paddles, plunger, and ball.
    
    // TODO:  Method to signal to the game the ball fell through the middle
    
    // TODO: Undo method to remove last component, ya know for mistakes ya dingus
    
    // Assists with switch the state and the textures of the play button and edit button
    fileprivate func switchStateAndTextures() {
        if(model.swapTextures)
        {
            self.playButton.switchTextures()
            self.editButton.switchTextures()
            model.swapTextures = false
        }
    }
    
    private func setupForPlayOrEdit(){
        if(model.removeTray)
        {
            baseComponents.removeLast()
            let plunger = Plunger()
            ball.positionX = 0 + 0.05
            ball.positionY = 0 - 0.05
            components.append(ball)
            debugDrawOfSorts(x: model.gridX - 2, y: model.gridY - 3, spr: plunger)
            model.removeTray = false
        }
        
        if(model.addTray)
        {
            self.tray = Tray()
            baseComponents.removeLast()
            baseComponents.append(tray)
            model.addTray = false
        }
    }
    
    // MARK: - Touches
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dummy = touches.first
        self.model.touchesBegan(touches, pixelTouch: (dummy?.location(in: glkView))!)
//        print("Frame height: \(glkView.frame.size.height) Frame Width: \(glkView.frame.size.width)")
/**
 *        let xy = (dummy?.location(in: glkView))!
 *        print("Raw finger touch: \(xy) calculated in the model")
 *
 *
 *
 *         // give the model all these hitboxes.
 *       if(self.playButton.hitbox.contains((dummy?.location(in: glkView))!))
 *       {
 *           print(" ")
 *           print(" -------- HIT DAT PLAY BUTTON BOOOI -------- ")
 *           print(" ")
 *
 *           switchStateAndTextures()
 *       }
 *       if(self.editButton.hitbox.contains((dummy?.location(in: glkView))!))
 *       {
 *           print(" ")
 *           print(" -------- HIT DAT EDIT BUTTON BOOOI -------- ")
 *           print(" ")
 *            switchStateAndTextures()
 *       }
 *
 *        if(model.editState)
 *        {
 *             * Check if the area is already populated with a component, if it is don't put anything there.
 *            print("X in Grid before round: \((xy.x/32.0))")
 *            print("Y in Grid before round: \((xy.y/32.0))")
 *
 *           var t = CGAffineTransform(scaleX: 1.0 / UIScreen.main.bounds.width, y: 1.0 / UIScreen.main.bounds.height);
 *           var unitRect = UIScreen.main.bounds.applying(t);
 *
 *            // This is the tray sliding in and out stuff.
 *           if(trayAreaTouch.contains((dummy?.location(in: glkView))!))
 *           {
 *               if(model.trayOut)
 *               {
 *                   model.trayOut = false
 *               }
 *               else
 *               {
 *                   print("TRAY TOUCHED")
 *                   model.trayOut = true
 *               }
 *           }
 *           else if(model.trayOut)
 *           {
 *               model.trayOut = false
 *           }
 *
 *
 *           if(self.undoButton.hitbox.contains((dummy?.location(in: glkView))!))
 *           {
 *               print(" ")
 *               print(" -------- HIT DAT UNDO BUTTON BOOOI -------- ")
 *               print(" ")
 *
 *                undoComponent()
 *           }
 *
 *            // Place the component that was selected
 *           model.componentSelected = true // DEBUG
 *            if(model.componentSelected)
 *            {
 *                let flooredX = round(xy.x/32)
 *                let flooredY = round(xy.y/32)
 *
 *                print("FloordX: \(flooredX) FlooredY: \(flooredY)")
 *                 * Depending on the selected component, make a new one proceed to place it.
 *                if(model.gameGrid[Int(flooredY)][Int(flooredX)] == 7)
 *                {
 *                    print("--- DRAWING A NEW COMPONENT ---")
 *                    print(" ")
 *                    print("Number in 2D array :: \(model.gameGrid[Int(flooredY)][Int(flooredX)])")
 *                    print(" ")
 *                    let i = Float(flooredX * 32)  * location of x tap
 *                    let k = Float(flooredY * 32)  * location of y tap
 *                    let w = Float(glkView.frame.size.width)
 *                    let h = Float(glkView.frame.size.height)
 *
 *
 *                     * START -- DEBUG PORTION
 *
 *                     * x = -1.0 + i * (2.0 / w) + (1.0 / w) = (2.0 * i + 1.0) / w - 1.0
 *                     * y = -1.0 + k * (2.0 / h) + (1.0 / h) = (2.0 * k + 1.0) / h - 1.0
 *
 *                     * i = (w / 2)(x + 1)
 *                     * k = (h - h * x) / 2
 *
 *                     *                let i = Float(xy.x)  * location of tap
 *                     *                let k = Float(xy.y)  * location of tap
 *                     *                let w = Float(glkView.frame.size.width)
 *                     *                let h = Float(glkView.frame.size.height)
 *
 *                    var component = Sprite()
 *                    switch model.componentValue{
 *                    case 0:
 *                        component = CircleBumper()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    case 1:
 *                        component = TriangleBumper()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    case 2:
 *                        component = Peg()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    case 3:
 *                        component = Flag()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    case 4:
 *                        component = Ball()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    default:
 *                        component = WallSprite()
 *                        component.setHitbox(x: flooredX, y: flooredY)
 *                    }
 *
 *                    let gridX = (2.0 * i + 1.0) / w - 1.0  *(2.0 * i) / w - 1.0
 *                    let gridY = (-2.0 * k + 1.0) / h + 1.0  *(-2.0 * k) / h + 1.0
 *
 *                    component.positionX = gridX + 0.05
 *                    component.positionY = gridY + -0.05
 *
 *                    print("X in gl: \(gridX)")
 *                    print("Y in gl: \(gridY)")
 *                    print("GridX: \(model.gridX)")
 *                    print("GridY: \(model.gridY)")
 *                    print("Pos X: \(component.positionX)")
 *                    print("Pos Y: \(component.positionY)")
 *
 *                    components.append(component)
 *                    drawComponents()
 *                }
 *        }
 *                 * END -- DEBUG PORTION
 *                else
 *                {
 *                    print(" ")
 *                    print(" --- DIDN'T DRAW A NEW COMPONENT ---")
 *                    print(" ")
 *                    print("Number in 2D array :: \(model.gameGrid[Int(flooredY)][Int(flooredX)])")
 *
 *                    let i = Float(flooredX * 32)  * location of x tap
 *                    let k = Float(flooredY * 32)  * location of y tap
 *                    let w = Float(glkView.frame.size.width)
 *                    let h = Float(glkView.frame.size.height)
 *                    let gridX = (2.0 * i + 1.0) / w - 1.0  *(2.0 * i) / w - 1.0
 *                    let gridY = (-2.0 * k + 1.0) / h + 1.0  *(-2.0 * k) / h + 1.0
 *                    print("X in gl: \(gridX)")
 *                    print("Y in gl: \(gridY)")
 *                }
 *            }
 *            else  * Pick the compoent to be placed
 *            {
 *                for i in 0 ..< self.hitboxesOfAddableComponents.count
 *                {
 *                    if (self.hitboxesOfAddableComponents[i].contains((dummy?.location(in: glkView))!))
 *                    {
 *                        model.componentSelected = true
 *                        print("Tapped on item at index: \(i)")
 *                        model.componentValue = i
 *                    }
 *                }
 *            }
 *        }
 *        else  * play mode time to shoot balls around
 *        {
 *            print("PLAY TIME BOOOOI")
 *        }
*/
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
                        component = Ball()
                    default:
                        component = WallSprite()
                    }
                    component.setHitbox(x: compPosition.flooredX, y: compPosition.flooredY)
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
        [595, 0, 16, 16]
        ]
        for i in 0 ..< 5
        {
            let test = TrayComponent()
//            test.setHitbox(x: 8 * 32, y: add * 32)
            test.hitbox = CGRect(x: 7 * 32 , y: add * 32, width: 96.0, height: 96.0)
            if(model.hitboxesOfAddableTrayComponents.count != 5)
            {
                model.hitboxesOfAddableTrayComponents.append(test.hitbox)
            }
            test.setTextureVertices(x: textureFloatArray[i][0], y: textureFloatArray[i][1], w: textureFloatArray[i][2], h: textureFloatArray[i][3])
            debugDrawOfSorts(x: 8, y: Int(add), spr: test)

//            components.append(test)
//            test.positionX = 0.5
//            test.positionY = add
            add += 3.0
//            if(i == 2)
//            {
//                test.width = 16.0
//                test.height = 32.0 * 2.0
//            }
//            if(i == 3)
//            {
//                test.width = 32.0
//                test.height = 29.0
//            }
        }
        

    }
    
    func undrawDrawComponentsOnTray()
    {
        for _ in 0 ..< 5
        {
            baseComponents.removeLast()
        }
    }
    
    func debugDrawGrid()
    {
        for y in 0 ..< model.gameGrid.count
        {
            for x in 0 ..< model.gameGrid[y].count
            {
                if(model.gameGrid[y][x] == 0)
                {
                    let component = WallSprite()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)

                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
//                    print("X in gl: \(gridX)")
//                    print("Y in gl: \(gridY)")
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
                    baseComponents.append(component)
                }
                if(model.gameGrid[y][x] == 8) // play button
                {
//                    let component = PlayButton()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    //                    print("X in gl: \(gridX)")
                    //                    print("Y in gl: \(gridY)")
                    playButton.positionX = gridX
                    playButton.positionY = gridY
                    baseComponents.append(playButton)
                }
                if(model.gameGrid[y][x] == 9) // edit button
                {
//                    let component = EditButton()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    //                    print("X in gl: \(gridX)")
                    //                    print("Y in gl: \(gridY)")
                    editButton.positionX = gridX
                    editButton.positionY = gridY
                    baseComponents.append(editButton)
                }
                if(model.gameGrid[y][x] == 10) // undo button
                {
//                    let component = un()
                    let i = Float(x * 32) // location of x tap
                    let k = Float(y * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    //                    print("X in gl: \(gridX)")
                    //                    print("Y in gl: \(gridY)")
                    undoButton.positionX = gridX
                    undoButton.positionY = gridY
                    baseComponents.append(undoButton)
                }
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
                    //                    print("X in gl: \(gridX)")
                    //                    print("Y in gl: \(gridY)")
                    component.positionX = gridX + 0.05
                    component.positionY = gridY + -0.05
//                    baseComponents.append(component)
                }
            }
        }
    }

    
}

