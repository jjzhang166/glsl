#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 5.0;
	
	float v = (pos.x * pos.y) * 12.0 + time;
	float a = sin(time * 150. + pow(mod(v - fract(v), 5.5)*0.25,2.));
	
	gl_FragColor = vec4(a*time, a, a, 1. );
}