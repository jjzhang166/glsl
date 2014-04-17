#ifdef GL_ES
precision mediump float;
#endif

// A sun looking thing
// by zach@cs.utexas

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand( vec2 co ) {
   return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	
	
	// float PI = 4.0*atan(1.0);
	float radius = length(gl_FragCoord.xy - resolution.xy/2.0);
	vec4 color = vec4(48.0/radius * (1.0 + sin(time)), 24.0/radius * (1.0 + cos(time)), 6.0/radius * (1.0 + tan(time)), 1.0);
	gl_FragColor = color;
}