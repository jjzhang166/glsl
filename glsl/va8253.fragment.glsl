#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 1.0;
    float size = resolution.x / 2.0;
    float g = 0.99;
    int num = 100;
    for (int i = 0; i < 29; ++i) {
        vec2 position = resolution / 2.0;
        position.x += cos(time / 3.0 + 1.0 * float((i))) * resolution.x * 0.25;
        position.y += cos(sin(time / 55.0 + (2.0 + sin(time) * 0.01) * float(i))) * resolution.y * 0.25;
        
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(0,0,1,1);
    float val = sum / float(num
			   );
    color = vec4(val*0.8, val*0.5, val*0.2, .3);
    
    gl_FragColor = vec4(color);
}