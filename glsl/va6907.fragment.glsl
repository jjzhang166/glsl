#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;

	float color = 0.0;
	color = sqrt(position.x * position.x * 13.0 + position.y * position.y * 13.0) * 2.0 + time;

	gl_FragColor = vec4( vec3( cos(color + 2.0 * time + 2.0), sin(time + color * 0.2), sin( color + time / 1.0 ) * 0.75 ), 2.0 );

}