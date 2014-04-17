#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy);

	float color = length(position);

	gl_FragColor = vec4( vec3(0.0, color, 0.0), 1.0 );
}