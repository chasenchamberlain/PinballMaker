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
        setup()
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
//        let thing = CGRect(x: -85, y: -148, width: 170, height: 296)
//        let hit = Hitbox(name: "Meh", w: 170, h: 296, x: -85, y: -148)
        print("2D ARRAY DIMENSIONS --> W:\(glkView.frame.size.width/32) H:\(glkView.frame.size.height/32)")

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        if(model.editState)
        {
            if(model.trayOut) // Tray is moving out
            {
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
        else
        {
            // fill me with stuff
        }
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
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
    }
    
    // MARK: - Intial Setup
    // Setups up our GameScene with appropriate walls etc.
    func setup()
    {
        model.setupTheGrid()
        let gameScreenBackground = GameScreen()
//        let rightWall =  WallSprite()
//        components.append(gameScreenBackground)

        
//        components.append(gameScreenBackgroundFloat(UIScreen.main.bounds.height))
//        components.append(rightWall)
        
        debugDrawGrid()
        components.append(tray)

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
        if(model.editState)
        {
            model.editState = false
        }
        else
        {
            model.editState = true
        }
        self.playButton.switchTextures()
        self.editButton.switchTextures()
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dummy = touches.first
        print("Frame height: \(glkView.frame.size.height) Frame Width: \(glkView.frame.size.width)")

        let xy = model.touchLocationToGameArea((dummy?.location(in: glkView))!)
        print("Raw finger touch: \(xy) calculated in the model")
        
        self.model.touchesBegan((dummy?.location(in: glkView))!)
        
        if(self.playButton.hitbox.contains((dummy?.location(in: glkView))!))
        {
            print(" ")
            print(" -------- HIT DAT PLAY BUTTON BOOOI -------- ")
            print(" ")
            
            switchStateAndTextures()
        }
        if(self.editButton.hitbox.contains((dummy?.location(in: glkView))!))
        {
            print(" ")
            print(" -------- HIT DAT EDIT BUTTON BOOOI -------- ")
            print(" ")
            
            switchStateAndTextures()
        }
        
        if(model.editState)
        {
            // Check if the area is already populated with a component, if it is don't put anything there.
            print("X in Grid before round: \((xy.x/32.0))")
            print("Y in Grid before round: \((xy.y/32.0))")
            
//            var t = CGAffineTransform(scaleX: 1.0 / UIScreen.main.bounds.width, y: 1.0 / UIScreen.main.bounds.height);
//            var unitRect = UIScreen.main.bounds.applying(t);
            
            // This is the tray sliding in and out stuff.
            if(trayAreaTouch.contains((dummy?.location(in: glkView))!))
            {
                if(model.trayOut)
                {
                    model.trayOut = false
                }
                else
                {
                    print("TRAY TOUCHED")
                    model.trayOut = true
                }
            }
            else if(model.trayOut)
            {
                model.trayOut = false
            }
 

            if(self.undoButton.hitbox.contains((dummy?.location(in: glkView))!))
            {
                print(" ")
                print(" -------- HIT DAT UNDO BUTTON BOOOI -------- ")
                print(" ")
                
                // make sure to stop undos at a certain point.
                components.removeLast()
            }
            
            // Place the component that was selected
//            model.componentSelected = true // DEBUG
            if(model.componentSelected)
            {
                let flooredX = round(xy.x/32)
                let flooredY = round(xy.y/32)
                
                print("FloordX: \(flooredX) FlooredY: \(flooredY)")
                // Depending on the selected component, make a new one proceed to place it.
                if(model.gameGrid[Int(flooredY)][Int(flooredX)] == 7)
                {
                    print("--- DRAWING A NEW COMPONENT ---")
                    print(" ")
                    print("Number in 2D array :: \(model.gameGrid[Int(flooredY)][Int(flooredX)])")
                    print(" ")
                    let i = Float(flooredX * 32) // location of x tap
                    let k = Float(flooredY * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    
                    
                    // START -- DEBUG PORTION
                    
                    // x = -1.0 + i * (2.0 / w) + (1.0 / w) = (2.0 * i + 1.0) / w - 1.0
                    // y = -1.0 + k * (2.0 / h) + (1.0 / h) = (2.0 * k + 1.0) / h - 1.0
                    
                    // i = (w / 2)(x + 1)
                    // k = (h - h * x) / 2
                    
                    //                let i = Float(xy.x) // location of tap
                    //                let k = Float(xy.y) // location of tap
                    //                let w = Float(glkView.frame.size.width)
                    //                let h = Float(glkView.frame.size.height)
                    let component = WallSprite()
                    
                    let gridX = (2.0 * i + 1.0) / w - 1.0 //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    
                    component.positionX = gridX + -0.035
                    component.positionY = gridY + -0.055
                    
                    print("X in gl: \(gridX)")
                    print("Y in gl: \(gridY)")
                    print("GridX: \(model.gridX)")
                    print("GridY: \(model.gridY)")
                    print("Pos X: \(component.positionX)")
                    print("Pos Y: \(component.positionY)")
                    
                    // component.positionX =
                    // component.positionY =
                    
                    components.append(component)
                    drawComponents()
                }
                // END -- DEBUG PORTION
                else
                {
                    print(" ")
                    print(" --- DIDN'T DRAW A NEW COMPONENT ---")
                    print(" ")
                    print("Number in 2D array :: \(model.gameGrid[Int(flooredY)][Int(flooredX)])")
                    
                    let i = Float(flooredX * 32) // location of x tap
                    let k = Float(flooredY * 32) // location of y tap
                    let w = Float(glkView.frame.size.width)
                    let h = Float(glkView.frame.size.height)
                    let gridX = (2.0 * i + 1.0) / w - 1.0 //(2.0 * i) / w - 1.0
                    let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
                    print("X in gl: \(gridX)")
                    print("Y in gl: \(gridY)")
                }
            }
            else // Pick the compoent to be placed
            {
                for i in 0 ..< self.hitboxesOfAddableComponents.count
                {
                    if (self.hitboxesOfAddableComponents[i].contains((dummy?.location(in: glkView))!))
                    {
                        model.componentSelected = true
                        print("Tapped on item at index: \(i)")
                    }
                }
            }
        }
        else // play mode time to shoot balls around
        {
            print("PLAY TIME BOOOOI")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesMoved(touches)
    }
    
    override func  touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesEnded(touches)
//        let touch = touches.first
//        let touchloc = touch?.location(in: glkView)
//        print("\(touchloc)")
    }
    
    fileprivate func debugDrawOfSorts(x: Int, y: Int, spr: Sprite) {
//        let component = WallSprite()
        spr.setQuadVertices()
        let i = Float(x * 32) // location of x tap
        let k = Float(y * 32) // location of y tap
        print("Grid Pixel X: \(i)")
        print("Grid Pixel X: \(k)")
        let w = Float(glkView.frame.size.width)
        let h = Float(glkView.frame.size.height)
        
        let gridX = (2.0 * i + 1.0) / w - 1.0  //(2.0 * i) / w - 1.0
        let gridY = (-2.0 * k + 1.0) / h + 1.0 //(-2.0 * k) / h + 1.0
         print("X in gl: \(gridX)")
         print("Y in gl: \(gridY)")
        spr.positionX = gridX + 0.05
        spr.positionY = gridY + -0.05
//        component.setTextureVertices(x: 627, y: 0, w: 32, h: 32)
        components.append(spr)
    }
    
    func drawComponentsOnTray()
    {
        var add: CGFloat = 4

        let floats: [[Float]] = [
        [116, 0, 32, 32],
        [148, 0, 32, 32],
        [180, 0, 16, 32],
        [403, 1, 32, 29],
        [595, 0, 16, 16]
        ]
        for i in 0 ..< 5
        {
            let test = TrayComponent()
            test.setHitbox(x: 8 * 32, y: add * 32)
            self.hitboxesOfAddableComponents.append(test.hitbox)
            test.setTextureVertices(x: floats[i][0], y: floats[i][1], w: floats[i][2], h: floats[i][3])
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
            components.removeLast()
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
                    components.append(component)
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
                    components.append(playButton)
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
                    components.append(editButton)
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
                    components.append(undoButton)
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
                    components.append(component)
                }
            }
        }
    }

    
}

