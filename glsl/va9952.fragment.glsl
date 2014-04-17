#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 uv;

float sdfLine(vec2 a, vec2 b, float w);
float line(vec2 a, vec2 b, float w);

#define s 4

void main( void ) {
	
	
	float rmin 	= min(resolution.x, resolution.y);
	float rmax 	= max(resolution.x, resolution.y);	
	vec2 uv 	= gl_FragCoord.xy / rmax;
	uv 		-= uv*.5;
	
	vec2 aspect 	= vec2(rmax/rmin);
	vec2 m 		= (mouse-.5);
	
	
	uv /= vec2(atan(m));
	
	float r;

	for(int i = 0; i < s; i++){
		uv = fract(uv*2.);
		r += step(1.3,abs(length(uv)));
	}
	
	uv = step(.33, uv) - step(.66, uv);

	gl_FragColor = vec4(r); //sphinx
}