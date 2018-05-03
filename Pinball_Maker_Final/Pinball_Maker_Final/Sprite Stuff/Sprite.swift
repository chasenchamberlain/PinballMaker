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
    internal var rotationZ : Float = 0.0
    
    internal var scaleX : Float = 1.0
    internal var scaleY : Float = 1.0
    internal var scale: Float = 1.0
    
    internal var width: Float = 0.0
    internal var height: Float = 0.0
    
    var hitbox: CGRect = CGRect()
    
    var vertices: [Float] = []
    
    var modelViewMatrix: GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, self.positionX, self.positionY, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(self.rotationZ), 1, 1, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, self.scaleX, self.scaleY, 0)

        return modelMatrix
    }
    
    internal var texture: GLKTextureInfo?
    
    var image: UIImage
    
    init()
    {
        self.image = UIImage(named: "Framed_Sprites")!
        
        texture = try? GLKTextureLoader.texture(with: self.image.cgImage!, options: nil)
        Sprite.setup()
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
        //glViewport(0, 0, GLsizei(375 * 2), GLsizei(667 * 2))
        
        // position
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad))
        
        // color
        glVertexAttribPointer(1, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 2)
        
        // texturePos
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(quad) + 6)

        // This matrix call is meant to make things more efficent
        glUniformMatrix4fv(glGetUniformLocation(Sprite.program, "modelView"), 1, 0, modelViewMatrix.array)
        glTexParameterf(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GLfloat(GL_NEAREST));

        if let texture = texture {
            glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
        }
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        
        
    }
    
    // Gives the position points of quad to assist in calculations of a hitbox
    public func getPositionVertices() -> [Float] {
        var verts: [Float] = []
        if !quad.isEmpty
        {
            // BL
            verts.append(quad[0])
            verts.append(quad[1])
            // BR
            verts.append(quad[8])
            verts.append(quad[9])
            // TL
            verts.append(quad[16])
            verts.append(quad[17])
            // TR
            verts.append(quad[24])
            verts.append(quad[25])
            
        }
        return verts
    }
    
    // Method to assist in switching textures from the sprite sheet
    public func setTextureVertices(x: Float, y: Float, w: Float, h: Float){

        let textureSizeX: Float = 1024.0
        let textureSizeY: Float = 32.0
//        let addedY = y + h
        let adjustedX: Float = x/textureSizeX
        var adjustedY: Float = (y+h)/textureSizeY
        if(y+h != textureSizeY)
        {
            adjustedY = y/textureSizeY
        }
        var newH = h
        if h == textureSizeY
        {
            newH = 0.0
        }
        
        
        if !quad.isEmpty
        {
            // TL
            (quad[6]) = adjustedX
            (quad[7]) = adjustedY
            
            // TR
            (quad[14]) = adjustedX + w/textureSizeX
            (quad[15]) = adjustedY
            
            // BL
            (quad[22]) = adjustedX
            (quad[23]) = newH/textureSizeY
            
            // BR
            (quad[30]) = adjustedX + w/textureSizeX
            (quad[31]) = newH/textureSizeY
        }
    }
    
    public func setQuadVertices(){
        
        if !quad.isEmpty
        {
            let posI_x = self.width / Float(UIScreen.main.bounds.width)
            let negI_x = posI_x * -1.0
            let posI_y = self.height / Float(UIScreen.main.bounds.height)
            let negI_y = posI_y * -1.0
            
            // BL
            (quad[0]) = negI_x
            (quad[1]) = negI_y
            // BR
            (quad[8]) = posI_x
            (quad[9]) = negI_y
            // TL
            (quad[16]) = negI_x
            (quad[17]) = posI_y
            // TR
            (quad[24]) = posI_x
            (quad[25]) = posI_y
        }
    }
    
    public func setHitbox(x: CGFloat, y: CGFloat){

        self.hitbox = CGRect(x: x, y: y, width: CGFloat(self.width), height: CGFloat(self.height))
    }
}

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}
