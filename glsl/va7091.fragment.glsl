#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = -5.0;
    float size = resolution.x / 050.0;
    float g = 1.9195;
    int num = 0;
    float m = 0.5;
    for (int i = 0; i < 1000; ++i) {
        vec2 position = resolution / 2.0;
	float z=2.0+sin(time / 2.0 + float(i)/(25.0+5.0*cos(time/3.0)));
        position.x += sin(time / 2.0 +float(i)/(45.0+5.0*cos(time/5.0))) * resolution.x * 0.10*z;
   	position.y += sin(time / 2.0 +float(i)/(30.0+5.0*cos(time/7.0))) * resolution.y * 0.10*z;
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist, g);
    }
    
    vec4 color = vec4(0,0,0,0);
    float val = sum / 20.0;
    color = vec4(val*1.0, val*0.2, val*0.0, 1);
    gl_FragColor = vec4(color);
}