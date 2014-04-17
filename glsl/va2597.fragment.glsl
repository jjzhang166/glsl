#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 50.0;
	
	float v = (pos.x * pos.y) * 5.0 + time;
	float a = mod(v - fract(v), 25.5);
	
	gl_FragColor = vec4(a, a, a, 1.0 );
}