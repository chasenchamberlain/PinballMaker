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
    
    // TODO:  variable for telling us if in edit or play
    // TODO:  variable for telling us if tray is out when editing
    
    private var model: Model!
    
    var components = [Sprite]()
    
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
        //        test.positionX -= 0.002
        //        test.positionY -= 0.0002
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 1.0, 0.0, 1.0)
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
        
        // TODO: Left wall
        // TODO: Top
        // TODO: Buttons
        // TODO: plunger
        // TODO: paddles
        // TODO: sloping walls to paddles
        
        components.append(gameScreenBackground)
//        components.append(rightWall)
        
        debugDrawGrid()
    }
    
    
    // TODO:  Method to set quad coridnates for paddles, plunger, and ball.
    
    // TODO:  Method to signal to the game the ball fell through the middle
    
    // TODO: Undo method to remove last component, ya know for mistakes ya dingus
    
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dummy = touches.first
        print("Frame height: \(glkView.frame.size.height) Frame Width: \(glkView.frame.size.width)")

        let xy = model.touchLocationToGameArea((dummy?.location(in: glkView))!)
        print("Raw finger touch: \(xy) calculated in the model")
        
        self.model.touchesBegan((dummy?.location(in: glkView))!)
        
        if(model.editState)
        {
            // Check if the area is already populated with a component, if it is don't put anything there.
            print("X in Grid before round: \((xy.x/32.0))")
            print("Y in Grid before round: \((xy.y/32.0))")
            
            
            // Place the component that was selected
            model.componentSelected = true // DEBUG
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
                    
                    component.positionX = gridX //+ 0.1
                    component.positionY = gridY //+ 0.01
                    
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
                
            }
        }
        else
        {
            
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
    
    func debugDrawGrid()
    {
        for y in 0 ..< model.gameGrid.count
        {
            for x in 0 ..< model.gameGrid[y].count
            {
                if(model.gameGrid[y][x] == 7)
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
            }
        }
        let editPlayButton = StartEditButton()
        components.append(editPlayButton)
    }

    
}

