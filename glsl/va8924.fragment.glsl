#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 sumCplx(vec2 a, vec2 b) {
	return vec2(a.x+b.x, a.y+b.y);
}

vec2 quadCplx(vec2 a) {
	return vec2(a.x*a.x - a.y*a.y , 2.0*a.x*a.y);
}

#define step 512
#define Kc   0.025

void main( void ) {

	float iter = 0.0;
	float zf = resolution.x * 0.5 + exp(time*0.25)*0.15;
	vec2 zomminCoord;
	
	zomminCoord = vec2(-0.745411,0.1);
	
	vec2 coord = vec2((gl_FragCoord.x - resolution.x*0.5)/zf,
			  (gl_FragCoord.y - resolution.y*0.5)/zf);
	
	coord += zomminCoord;
	
	vec2 z = vec2(sin(time*0.013), 0);
	
	for(int i=0; i < step; i++) {
		
		iter += 1.00;
		
		z = quadCplx(z) + coord;
		if (z.x*z.x + z.y*z.y > 2.5) {
			gl_FragColor = vec4((iter * Kc)*2.0, (iter * Kc)*0.5, 1.0-(iter * Kc)*1.5,  1.0 );
			return;
		}
	}
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
}