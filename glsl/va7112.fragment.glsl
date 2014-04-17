#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color = vec3(0.0);
	vec2 position = gl_FragCoord.xy;
	
	position.x += time * 100.0;
	position.y += time * 100.0;
	
	color = vec3(.25, .25, .25);
	
	for (int i = 0; i < 9; ++i) {
		float total_squares = pow(3.0, float(i));
		float sq_size = (10000.0) / total_squares;
		
		float x = mod(position.x / sq_size, 3.0);
		float y = mod(position.y / sq_size, 3.0);
		
		if (int(x) == 1 && int(y) == 1) {
			color = vec3(.0);
			break;
		}
	}
	gl_FragColor = vec4( color, 1.0 );

}