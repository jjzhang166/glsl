#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 0.0;
    float size = resolution.x / 1.3;
    float g = 0.9;
    int num = 80;
    for (int i = 0; i < 50; ++i) {
        vec2 position = resolution / 2.0;
        position.x += sin(time / 18.0 + 0.9 * float(i)) * resolution.x * 0.5;
        position.y += cos(time /19.0 + (1.0 + sin(time) * 0.0001) * float(i)) * resolution.y * 0.5;
        
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(0,0,0,1);
    float val = sum / float(num
			   );
    color = vec4(0, val*0.4, val, 1);
    
    gl_FragColor = vec4(color);
}