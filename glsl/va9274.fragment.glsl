#ifdef GL_ES
precision mediump float;
#endif

#define GAP 10.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 position = gl_FragCoord.xy;
	
	if (floor(mod(position.x, GAP)) == 0.0 &&  floor(mod(position.y, GAP)) == 0.0) {
		gl_FragColor = vec4(vec3(3.0, 5.0, 1.0), 12.0); 
		return; 
	}
	
	
}