#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color = vec3(0.0);
	vec2 position = gl_FragCoord.xy;

	
	color = vec3(.1, .4, .5);
	
	for (int i = 0; i < 8; ++i) {
		float total_squares = pow(3.0, float(i));
		float sq_size = (1000.0 + mod(time * 1000.0, 2000.0)) / total_squares;
		
		float x = mod(position.x / sq_size, 3.0);
		float y = mod(position.y / sq_size, 3.0);
		
		if (int(x) == 1 && int(y) == 1) {
			color = vec3(.0);
			break;
		}
	}
	gl_FragColor = vec4( color, 1.0 );

}