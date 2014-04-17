#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592

void main( void ) {
	
	float curve = sin((gl_FragCoord.x/resolution.x*PI*5.0)+sin(abs(mouse.x) * 10.0)*1.0);
	curve *= resolution.y/3.0;
	curve += resolution.y/2.0;
	
	if (gl_FragCoord.x + 1.0 >= (mouse.x * resolution.x) && gl_FragCoord.x <= (mouse.x * resolution.x) + 1.0) {
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	} else if(gl_FragCoord.y > curve && gl_FragCoord.y < curve + 5.0){
		gl_FragColor = vec4(0.0, 1.0, 1.0, 1.0);
	} else {
		discard;	
	}
}