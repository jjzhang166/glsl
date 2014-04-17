#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
const float max_iteration = 300.0;

void main( void ) {
	vec2 n = surfacePosition * 1.5 + vec2(-0.4, 0.0);
	vec2 p = vec2(0.0);
	float iteration = 0.0;
	for (float i = 0.0; i < max_iteration; ++i) {
		if (dot(p,p) > 4.0) {
			break;
		}
		p = vec2(p.x*p.x - p.y*p.y, 2.0*p.x*p.y) + n;
		++iteration;
	}
	float color = iteration / max_iteration;
	
	gl_FragColor = vec4(color*0.7, color, color*0.9, 1.0);
}