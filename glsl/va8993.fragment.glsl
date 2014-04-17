#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
    
    float sum = .5;
    float size = resolution.x / 1.5;
	
    float t = time;
	
    vec2 position = resolution / 2.0;
    position.x += 0.0;
    position.y += 0.0;
        
    float dist = length(gl_FragCoord.xy - position);
    
    vec4 color = vec4(0.0,0.4,0.5,1.0);
    float val = size /(30.0*pow(dist, 0.95));
    color += vec4(val, val*(0.8+0.2*sin(t/2.0)), val, 1.0);
    
    gl_FragColor = vec4(color);
}