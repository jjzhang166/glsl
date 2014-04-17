#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float size = 32.0;

void main( void ) {
	
	vec3 color = vec3(floor(time));
		
	gl_FragColor = vec4( color , 1.0 );
}