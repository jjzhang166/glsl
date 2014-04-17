#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float t = 100.*time;

void main( void ) {

	float dist = distance(gl_FragCoord.xy, mouse.xy) * time/resolution.x;
	gl_FragColor = vec4( sin(dist * t), cos(dist * t), tan(dist* t), 1.0);
}