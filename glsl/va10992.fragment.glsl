#ifdef GL_ES
precision mediump float;
#endif
#define M_PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float ratio = resolution.x / resolution.y;
	vec2 position = (gl_FragCoord.xy / resolution.x);
	float dist = distance(position, vec2(0.5, 0.5 / ratio)) * 2.0;
	gl_FragColor = vec4( (vec3((sin(time * 10.0 + dist * 40.0) + 1.0) * 0.5)), 1.0);
	//gl_FragColor = vec4( (vec3( sin(time), sin(time + 0.33 * M_PI), sin( time + 0.66 * M_PI)) + 1.0) * 0.5, 1.0 );

}