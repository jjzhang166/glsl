#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// sky and sunrise

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = (floor((position.x* position.y*sin(mod(time,3.14))*1.0)*16.0+mod(time*3.0,1.0)) )/16.0;
	float g = 0.0;
	float b = 0.0;
	
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}