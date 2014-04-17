#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position =  gl_FragCoord.xy / resolution.xy;
		
	int i;
			float cr = 1.0 - 0.5 * sin(time);
		float ci = - 0.6 * cos(time) + 1.5;
	

	float pr = position.x * 3.0 - 1.0;
	float pi = position.y * 2.0 - 1.0;
	
	
	int it;
	for (int i = 0; i < 128; ++i) {
		it = i;
		
		float tr = pr * pr - pi * pi;
		float ti = 2.0 * pr * pi;
	
		
		pr = tr + cr;
		pi = ti + ci;
		if (pr * pr + pi * pi >= 4.0) {
			break;
		}
	}

	float color = 0.0;

	float R;
	float B;
	float G;
	
	if (it >= 127) {
		R = 0.0;
		G = 0.0;
		B = 0.0;
	} else {
		R = float(it) / 128.0;
		G = cos(float(it) / 128.0 + 3.14 / 4.0);
		B = sin(float(it) / 128.0 + 523.0);
	}
	
	gl_FragColor = vec4( R,G,B, 1.0 );

}