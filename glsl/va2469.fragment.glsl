#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec2 pos = p * 25.0 * cos(sin(time/5.0));
	
	float v = (sin(pos.x) * cos(pos.y)) * 1.0 + time;
	float a = mod(v - fract(v), 1.5);
	
	gl_FragColor = vec4(a, 1.0 - a, a, 1.0 );
}