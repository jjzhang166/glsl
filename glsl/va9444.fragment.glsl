#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
uniform float time;
const float max_iteration = 400.0;

void main( void ) {
	float testingnumber = abs(cos(time));
	
	vec2 p = vec2(0.0);
	
	float iteration = 0.0;
	for (float i = 0.0; i < max_iteration; ++i) {
		
		if (dot(p,p) > 4.0) { break; }
		
		p = vec2(
			p.x*p.x - p.y*p.y,
			2.0*p.x*p.y
		) + surfacePosition;
		
		++iteration;
	}
	float color = iteration/max_iteration;
	gl_FragColor = vec4(color,color,color, 1.0);
}