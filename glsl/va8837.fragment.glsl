#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float square_size = 150.0;

void main( void ) {
	vec2 position = gl_FragCoord.xy + mouse.xy*resolution.xy;
	
	position = mod(floor(position/square_size),2.0);
	float color = abs(position.x - position.y);
		
	gl_FragColor = vec4( vec3(color,0.0,0.0), 1.0 );
}