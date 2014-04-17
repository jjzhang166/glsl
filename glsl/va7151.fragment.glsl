#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = position.x;
	float g = position.y / 2.0;
	float b = position.x * position.y;

	gl_FragColor = vec4( vec3( r,g, b), 1.0 );

}

