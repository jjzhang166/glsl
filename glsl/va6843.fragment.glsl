#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 resolution;
 
const int k = 7;
const int stripes = 30;
const vec3 color = vec3(136, 86, 167);
void main( void ) {
	float PI = 4.0 * atan(1.0);
 
	vec2 res2 = resolution;
	float phase = 2.0*PI*time/3.0;
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
		c+=cos((xy.x*ct+xy.y*st)*2.0*PI*float(stripes)/resolution.x+phase);  
	}
	float cScaled = (c+float(k))/(float(k)*2.0);
	gl_FragColor = vec4(color * cScaled / 255.0, 1.0);
}
