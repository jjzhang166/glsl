#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float dist = distance(gl_FragCoord.xy, mouse.xy) * time/resolution.x;
	gl_FragColor = vec4( sin(dist * time), cos(dist * time), tan(dist* time), 1.0);
}