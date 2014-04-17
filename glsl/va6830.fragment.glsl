#ifdef GL_ES
precision mediump float;
#endif

// by William Ridgers

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int iterations = 200;

float fractal(vec2 c) {
	vec2 z 		= vec2(0,0);
	int k 		= 0;
	
	for(int i = 0; i < iterations; i++){
		float zxSq = z.x * z.x;
		float zySq = z.y * z.y;
		
		if (zxSq + zySq > 4.0) break;
		
		float temp = zxSq - zySq + c.x;
		z.y = 2.0*z.x*z.y + c.y;
		z.x = temp;
		
		k++;
	}
	
	// normalise iteration count
	float normalised = float(k) + 1.0 - float(log(log(sqrt(z.x * z.x + z.y * z.y))))/float(log(2.0));
	
	return (k == iterations) ? 0.0 : normalised/float(iterations);
}

void main( void ) {
	
	vec2 aim = vec2(0, 0);
	float zoom = 0.4;
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(.7,.5);
	pos 	*= 1.0/zoom;	
	pos.y 	*= resolution.y/resolution.x;

	
	gl_FragColor = vec4( fractal(pos)*vec3(0,1,0), 1.0 );

}