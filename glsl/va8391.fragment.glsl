#ifdef GL_ES
precision mediump float;
#endif

// Mostly a copy of http://glsl.heroku.com/e#8250.0
// Minor changes to dot position/"colour", and add trails using temporal blur

uniform float time;
uniform vec2 resolution;
uniform sampler2D backBuffer;
uniform vec4 colors;

void main( void ) {
    vec2 absPosition = ( gl_FragCoord.xy / resolution.xy );
    vec4 newFrame = texture2D(backBuffer, absPosition);
	
    float sum = 0.0;
    float size = resolution.x / 2.0;
    float g = .99;
    int num = 31;
    for (int i = 0; i < 31; ++i) {
        vec2 position = resolution / 2.0;
        position.x += tan(sin(10.0*float(i)) * time / 3.0 + 1.0 * float(i)) * resolution.x * 0.25;
        position.y += tan(tan(2.0*float(31-i)) * time / 100.0 + (2.0 + sin(time) * 0.01)) * resolution.y * 0.25;
        
        float dist = length(gl_FragCoord.xy - position);
        float cu = sum;
        sum += size / pow(dist/.3, g) + sum * 0.05;
	    sum *= size / pow(dist/1.6, g + 0.2);
    }
    
    vec4 color = vec4(0,0,1,1);
    float val = sum / float(num);
    color = vec4(val*0.1, val*0.5*absPosition.y, val*.2+(0.2*sin(time*0.1)), 1);
    newFrame = (0.07*vec4(color)) + (0.9*vec4(newFrame));

    gl_FragColor = newFrame;
    //gl_FragColor = color;
}