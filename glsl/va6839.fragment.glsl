#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 resolution;
 
const int k = 7;
const int stripes = 120;
const vec3 color = vec3(136, 86, 167);

float sawtooth(float value) {
	return mod(floor(value), 2.0) == 0.0 ? fract(value) : 1.0 - fract(value);
}

void main( void ) {
	float PI = 4.0 * atan(1.0);
 
	float omega = (sin(time * 0.2) + 1.0) / 2.0;
	
	vec2 res2 = resolution/2.0;
	vec2 xy = (gl_FragCoord.xy - res2);
	float theta = atan(xy.y, xy.x);
	float r = log(length(xy*xy));
	float c = 0.0;
	for (int t = 0; t < k; t++) {
		float tScaled = PI*float(t)/float(k);
		float ct = cos(tScaled);
		float st = sin(tScaled);
		//c+=cos((theta*ct-r*st)*float(stripes)+phase);
		// use the following line for cartesian crystals:  
		c+=cos((xy.x*ct+xy.y*st)*float(stripes)/resolution.x+2.0*PI*time/3.0+sin(float(t)*2.0*PI*omega));  
	}
	float ans = sawtooth(c + float(k) / 2.0);
	gl_FragColor = vec4(color * ans / 255.0, 1.0);
}
