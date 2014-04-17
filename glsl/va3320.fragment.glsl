// look into my eyes...
// @simesgreen
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	p.x *= resolution.x / resolution.y;

	const float a = 1.0;
	
	float t = (atan(p.y, p.x) + 3.14159) / 3.14159;
	float r = a*t;
	//float r = exp(a*t);
	r += time;

	float r2 = length(p);
	float r3 = r2 * pow(r2,2.);
	r3 = .1/r2;
	r2 = r - pow(r2, time/100.)*3.0;
	r3 = r - r3*3.0;
	r2 = fract(r2);
	r3 = fract(r3);

	vec3 c = vec3(0.);
	if(r2 > 0.8){
		if(r3 > 0.8){
			c = vec3(0.);
		}else{
			c = vec3(1., 0., 0.);
		}
	}else{
		if(r3 > 0.8){
			c = vec3(1.);
		}else{
			c = vec3(0., 1., 1.);
		}
	}
	gl_FragColor = vec4( c, 1 );
}