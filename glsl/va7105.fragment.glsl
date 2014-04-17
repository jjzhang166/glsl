#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 last_mouse;

void main( void ) {
    float scale = (last_mouse.x - mouse.x)* (last_mouse.y - mouse.y) * 1000.;
    last_mouse = mouse;
    float sum = 0.0;
    float size = resolution.x / 5.0;
    float g = .95;
    int num = 100;
    for (int i = 0; i < 10; ++i) {
        vec2 position = mouse * resolution;
        position.x += sin(time / 3.0 + 1.0 * float(i))  * 0.25 * scale;
        position.y += cos(time / 3.0 + (2.0 + sin(time) * 0.01) * float(i))  * 0.25 * scale;
        
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(0,0,0,1);
    float val = sum / float(num);
    color = vec4(0, val*0.8, val, 1);
    
    gl_FragColor = vec4(color);
}