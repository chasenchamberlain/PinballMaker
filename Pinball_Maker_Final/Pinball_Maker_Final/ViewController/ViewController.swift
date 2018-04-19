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
//    private var program: GLuint = 0
    
    //    private var translateX: Float = 0.0
    //    private var translateY: Float = 0.0
    //    private var time: Float = 0.0
    
    private var model: Model!
    var components = [Sprite]()
    
    //    private var model: Model
    
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
    
    // Setups up our GameScene with appropriate walls etc.
    func setup()
    {
        let gameScreenBackground = GameScreen()
        let rightWall =  WallSprite()
        components.append(gameScreenBackground)
        components.append(rightWall)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesBegan()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesMoved()
    }
    
    override func  touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.touchesEnded()
    }
    
}

