// water turbulence effect by joltz0r 2013-07-04
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;


#define MAX_ITER 32
void main( void ) {

	vec2 p = surfacePosition*4.0;
	vec2 i = p;
	float c = 0.0;
	float inten = 0.8;
	
	for (int n = 0; n < MAX_ITER; n++) {
		float t = time * (1.0 - (1.0 / float(n+1)));
		c = length(vec2(
			6.3 + (sin(i.x)*inten),
			4.0 + (cos(i.y)*inten)
			)
		);
		i = p + vec2(
			cos(t - i.x) + sin(t + i.y), 
			sin(t - i.y) + cos(t + i.x)
		);
	}
	gl_FragColor = vec4(vec3(cos(c))*vec3(0.95, 0.97, 1.8), 1.0);
}