#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 delta = gl_FragCoord.xy - mouse;
	float dist = length(delta) * length(delta);
	float color = float(dist < 100.0 ? 1 : 0);
	
	gl_FragColor = vec4( vec3( color, color, color), 1.0 );
}