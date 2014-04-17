#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
const float max_iteration = 100.0;

void main( void ) {
	vec2 n = surfacePosition * 2.0 + vec2(-0.2, 0.0);
	vec2 p = vec2(0.0);
	
	float iteration = 0.0;
	for (float i = 0.0; i < max_iteration; ++i) {
		if (dot(p,p) > 2.0) {
			break;
		}
		p = vec2(p.x*p.x - p.y*p.y, 2.0*p.x*p.y) + n;
		 p *= 1.025;
		++iteration;
	}
	float shade = iteration / max_iteration * 0.5;
	
	gl_FragColor = vec4(shade*0.2, shade*0.6, shade*0.99, 1.0);
}