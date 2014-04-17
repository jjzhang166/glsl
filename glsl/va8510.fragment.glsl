#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy - 0.5 ) * 0.1 - 0.5 + mouse / 2.0) * 3.0;

	float x0 = position.x;
	float y0 = position.y;
	
	float x = 0.0;
	float y = 0.0;
	
	int iteration = 0;
	
	for (int i = 0; i < 1024; i++) {
		if (x*x + y*y >= 4.0) {
			break;
		}

		float xtemp = x*x - y*y + x0;
		y = 2.0*x*y + y0;
		
		x = xtemp;
		
		iteration += 1;
	}
	
	float col = float(iteration/8) / 8.0;
	
	//gl_FragColor = vec4(col, 0.0, 0.0, 1.0);

	gl_FragColor = vec4( vec3( col, col * 0.5, sin( col + time / 3.0 ) * 0.75 ), 1.0 );

}