#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// sky and sunrise

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
		
	r = (1. - position.y) * sin(time) + 0.6;
	g = (1. - position.y) * sin(time) + 0.6;
	b = 0.8;
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}