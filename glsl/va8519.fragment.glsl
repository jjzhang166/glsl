#ifdef GL_ES
precision mediump float;
#endif

/*
Hope you had an incredible birthday dana!
this is something pretty i found here

-kawalla
*/

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 1.0;
    float size = resolution.x / 2.0;
    float g = .99;
    int num = 100;
    for (int i = 0; i < 42; ++i) {
        vec2 position = resolution / 2.0;
        position.x += sin(time / 3.0 + 1.0 * float(i)) * resolution.x * 0.25;
        position.y += tan(time / 556.0 + (2.0 + sin(time) * 0.01) * float(i)) * resolution.y * 0.25;
        
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(1,0,0,1);
    float val = sum / float(num
			   );
    color = vec4(val*0.5, val*0.5, val*0.5, 1);
    
    gl_FragColor = vec4(color);
}