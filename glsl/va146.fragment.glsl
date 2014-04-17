// THIS WAS NOT INTENDED! SORRY!

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

// Backbuffer fetch
vec4 bbf(vec2 pos)
{
    return texture2D( backbuffer, pos );
}

void main()
{

    gl_FragColor =  vec4(1.,1.,1.,1.) ;
}
