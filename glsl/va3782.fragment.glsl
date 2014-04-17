#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy  - vec2(0.5)) * 4. + mouse / 2.0;

	vec2 z = position;
	int iter = 0;
	for (int i = 0; i < 64; ++i) {
		float x = (z.x * z.x - z.y * z.y) + position.x;
		float y = (z.y * z.x + z.x * z.y) + position.y;
		
		if (x * x + y * y > 4.) {
			iter = i;
			break;
		}
		
		z = vec2(x,y);
	}
	
	float d = iter == 64 ? 0.0 : (float(iter) / 64.);
	
	gl_FragColor = vec4(vec3(sin(time)*d,d*d,cos(time)*d),1.0);
}