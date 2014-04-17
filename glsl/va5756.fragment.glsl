
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
    //gl_FragCoord treats the origin as the bottom left of the window
   
    //it looks like the mouse uniform being passed in is from 0.0 - 1.0 with the bottom left as the origin
   
    // Normalize the FragCoord
    vec2 position = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
    float aspect = resolution.x/resolution.y;
   
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
   
    // top left red
    // bottom left blue
    // top right green
    // bottom right yellow
   
    // breaking down what I wanted out of each color component helped
   
    gl_FragColor.r = (1.0 - sqrt((mouse.x - position.x)*(mouse.x - position.x) + (mouse.y - position.y)*(1.0/aspect)*(1.0/aspect)*(mouse.y - position.y))*10.0)*abs(sin(min(mod(time, 3.0*3.14), 3.14)));
    gl_FragColor.g = (1.0 - sqrt((mouse.x - position.x)*(mouse.x - position.x) + (mouse.y - position.y)*(1.0/aspect)*(1.0/aspect)*(mouse.y - position.y))*10.0)*abs(sin(min(mod(time+2.0*3.14, 3.0*3.14), 3.14)));
    gl_FragColor.b = (1.0 - sqrt((mouse.x - position.x)*(mouse.x - position.x) + (mouse.y - position.y)*(1.0/aspect)*(1.0/aspect)*(mouse.y - position.y))*10.0)*abs(sin(min(mod(time+1.0*3.14, 3.0*3.14), 3.14)));
   

}
