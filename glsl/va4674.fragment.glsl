#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
varying vec2 surfacePosition;
const float max_iteration = 200.0;

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
	
	const float f = 100.0, inf = 1.0 / max_iteration;
	float shade = 1.0 - mod(time * 0.5 - iteration * inf, 1.5);
	shade *= shade;
	if (iteration == max_iteration)
		shade = 0.0;
	
	gl_FragColor = vec4(shade, shade, shade, 1.0);
}