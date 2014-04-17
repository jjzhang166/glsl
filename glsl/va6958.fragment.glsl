#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592

void main( void ) {
	
	float curve = sin((gl_FragCoord.s/resolution.s*PI*5.0)+time*1.0);
	curve *= resolution.t/3.0;
	curve += resolution.t/2.0;
	
	if(gl_FragCoord.t > curve && gl_FragCoord.t < curve + 5.0){
		gl_FragColor = vec4(0.0, 1.0, 1.0, 1.0);
	}
}