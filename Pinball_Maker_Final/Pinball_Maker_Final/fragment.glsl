varying highp vec2 textureCoordinateInterpolated;
uniform sampler2D textureUnit;
//varying lowp vec4 frag_Color;

void main()
{
    gl_FragColor = texture2D(textureUnit, textureCoordinateInterpolated);
}

