//
//  Sprite.swift
//  Project-Final-Pinball-Maker
//
//  Created by Chasen Chamberlain on 4/12/18.
//  Copyright © 2018 Chasen Chamberlain. All rights reserved.
//

import GLKit

class Sprite {
    private static var program: GLuint = 0
    
    internal var quad: [Float] = []
    
    internal var positionX: Float = 0.0
    internal var positionY: Float = 0.0
    
    internal var rotation: Float = 0.0
    
    let components = [Sprite]()
    
    internal var rotationX : Float = 0.0
    internal var rotationY : Float = 0.0
    
    internal var scaleX : Float = 1.0 { didSet{self.computeWidth()} }
    internal var scaleY : Float = 1.0 { didSet{self.computeHeight()} }
    internal var scale: Float = 1.0
    
    internal var width: Float = 0.0
    internal var height: Float = 0.0
    
    var vertices: [Float] = []
    
    var modelViewMatrix: GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.positionX, self.positionY, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0)
        //        modelMatrix = GLKMatrix4Rotate(modelMatrix, 0, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.scaleX, self.scaleY, 1)
        return modelMatrix
    }
    
    //    var name: String
    
    internal var texture: GLKTextureInfo?
    
    let image: UIImage
    
    init(image: UIImage)
    {
        self.image = image
        //        self.name = name
        texture = try? GLKTextureLoader.texture(with: self.image.cgImage!, options: nil)
        computeVolumn()
        Sprite.setup()
    }
    
    fileprivate func computeVolumn() {
        self.computeWidth()
        self.computeHeight()
    }
    
    fileprivate func computeWidth() {
        let xs = self.vertices.map{ $0 }
        let minX = xs.min() ?? 0
        let maxX = xs.max() ?? 0
        self.width = (maxX - minX) * self.scaleX * self.scale
    }
    
    fileprivate func computeHeight() {
        let ys = self.vertices.map{ $0 }
        let minY = ys.min() ?? 0
        let maxY = ys.max() ?? 0
        self.height = maxY - minY * self.scaleY * self.scale
    }
    
    private static func setup()
    {
        if program != 0
        {
            return
        }
        
        // --- Setup vertex shader ---
        let vertexShaderPath: String = Bundle.main.path(forResource: "vertex", ofType: "glsl", inDirectory: nil)!
        let vertexShaderSource: NSString = try! NSString(contentsOfFile: vertexShaderPath, encoding: String.Encoding.utf8.rawValue)
        var vertexShaderData = vertexShaderSource.cString(using: String.Encoding.utf8.rawValue)
        let vertexShader: GLuint = GLuint(glCreateShader(GLenum(GL_VERTEX_SHADER)))
        glShaderSource(vertexShader, 1, &vertexShaderData, nil)
        glCompileShader(vertexShader)
        
        var vertexShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexShaderCompileStatus)
        
        if vertexShaderCompileStatus == GL_FALSE
        {
            var logLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetShaderInfoLog(vertexShader, logLength, nil, logBuffer)
            let logString: String = String(cString: logBuffer)
            print(logString)
            fatalError("Error: VertexShader didn't compile")
        }
        
        // --- Setup fragment shader --
        let fragmentShaderPath: String = Bundle.main.path(forResource: "fragment", ofType: "glsl", inDirectory: nil)!
        let fragmentShaderSource: NSString = try! NSString(contentsOfFile: fragmentShaderPath, encoding: String.Encoding.utf8.rawValue)
        var fragmentShaderData = fragmentShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let fragmentShader: GLuint = GLuint(glCreateShader(GLenum(GL_FRAGMENT_SHADER)))
        
        glShaderSource(fragmentShader, 1, &fragmentShaderData, nil)
        glCompileShader(fragmentShader)
        
        var fragmentShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatus)
        
        if fragmentShaderCompileStatus == GL_FALSE
        {
            var logLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetShaderInfoLog(fragmentShader, logLength, nil, logBuffer)
            let logString: String = String(cString: logBuffer)
            print(logString)
            fatalError("Error: FragmentShader didn't compile")
        }
        
        // Link the OpenGL program
        program = glCreateProgram()
        glAttachShader(program,  vertexShader)
        glAttachShader(program, fragmentShader)
        glBindAttribLocation(program, 0, "position")
        glBindAttribLocation(program, 1, "color")
        glBindAttribLocation(program, 2, "texturePos")
        glLinkProgram(program)
        
        var linkStatus: GLint = GL_FALSE
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        
        if linkStatus == GL_FALSE
        {
            var logLength: GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            
            glGetProgramInfoLog(program, logLength, nil, logBuffer)
            let logString: String = String(cString: logBuffer)
            
            print(logString)
            fatalError("Program did not link")
            
        }
        // Define the OpenGL program
        glUseProgram(program)
        glEnableVertexAttribArray(0)
        glEnableVertexAttribArray(1)
        glEnableVertexAttribArray(2)
        
    }
    
    internal func draw()
    {
        //        glViewport(bounds.width, y: Glint, width: GLsizei, height: GLsizei) This does something with keeping a square on screen I guess
        
        // position
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad))
        
        // color
        glVertexAttribPointer(1, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 2)
        
        // texturePos
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 6)
        
        //        glUniform2f(glGetUniformLocation(Sprite.program, "translate"), positionX, positionY)
        //        glUniform2f(glGetUniformLocation(program, "scale"), scaleX, scaleY)
        //        glUniform1f(glGetUniformLocation(program, "rotation"), roation)
        
        // This matrix call is meant to make things more efficent
        glUniformMatrix4fv(glGetUniformLocation(Sprite.program, "modelView"), 1, 0, modelViewMatrix.array)
        
        if let texture = texture {
            glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
        }
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
    
    // Bounding box for collision/clicky things
    internal func boundingBoxWithModelViewMatrix(parenetModelViewMatrix: GLKMatrix4) -> CGRect {
        let modelViewMatrix = GLKMatrix4Multiply(parenetModelViewMatrix, self.modelViewMatrix)
        
        let preLowerLeft = GLKVector4Make(self.width, self.height, 0, 1)
        let lowerLeft = GLKMatrix4MultiplyVector4(modelViewMatrix, preLowerLeft)
        
        let preUpperRight = GLKVector4Make(self.width, self.height, 0, 1)
        let upperRight = GLKMatrix4MultiplyVector4(modelViewMatrix, preUpperRight)
        
        let boundingBox = CGRect(x: CGFloat(lowerLeft.x),
                                 y: CGFloat(lowerLeft.y),
                                 width: CGFloat(upperRight.x - lowerLeft.x),
                                 height: CGFloat(upperRight.y - lowerLeft.y))
        return boundingBox
    }
    
    // Gives the position points of quad to assist in calculations of a hitbox
    public func getPositionVertices() -> [Float] {
        var verts: [Float] = []
        if !quad.isEmpty
        {
            verts.append(quad[0])
            verts.append(quad[1])
            
            verts.append(quad[8])
            verts.append(quad[9])
            
            verts.append(quad[16])
            verts.append(quad[17])
            
            verts.append(quad[24])
            verts.append(quad[25])
            
        }
        return verts
    }
    
    // Method to assist in switching textures from the sprite sheet
    public func setTextureVertices(newTexurePoints: [Float]){

        if !quad.isEmpty
        {
            (quad[6]) = newTexurePoints[0]
            (quad[7]) = newTexurePoints[1]
            
            (quad[14]) = newTexurePoints[2]
            (quad[15]) = newTexurePoints[3]
            
            (quad[22]) = newTexurePoints[4]
            (quad[23]) = newTexurePoints[5]
            
            (quad[30]) = newTexurePoints[6]
            (quad[31]) = newTexurePoints[7]
        }
    }
}

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}
