#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// sky and sunrise

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = (floor(position.x*16.0) + position.y)/16.0;
	float g = 0.0;
	float b = 0.0;
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}