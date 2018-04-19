attribute vec2 position;
attribute vec2 texturePos;
attribute vec4 color;

uniform highp mat4 modelView;

uniform vec2 translate;
uniform vec2 scale;
uniform float rotation;

varying vec4 colorInterpolated;
varying vec2 textureCoordinateInterpolated;

void main()
{
    gl_Position = modelView * vec4(position.x, position.y, 0.0, 1.0);
    
    colorInterpolated = color;
    textureCoordinateInterpolated = texturePos;
}

