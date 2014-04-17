#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	
	float x = gl_FragCoord.xy.x / 1.0;
	float y = gl_FragCoord.xy.y / 1.0;
	int end = int(mod(float(time), 5.0));
	float pass=0.0;
	
	for (int i = 0; i < 100; i++) {
		if (int(mod(x, 3.0)) == 1 && int(mod(y, 3.0)) == 1) {
			pass = sqrt(float(i) / 2.0);
			break;
		}
		if (i > end) {
			break;
		}
		x = x/3.0;
		y = y/3.0;
	}
		

	gl_FragColor = vec4( vec3(pass, pass, pass ), 1.0 );

}