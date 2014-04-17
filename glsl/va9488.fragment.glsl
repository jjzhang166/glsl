#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define SQRT2 1.4142

#define TIMESCALE 0.8

float movement(float x);

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy)*2. - vec2(1.);
	p.x *= resolution.x/resolution.y;
	
	float val = 0.;
	
	float prog = movement(time * TIMESCALE);
	float prog2 = movement(time * TIMESCALE + 0.25);
	
	vec2 c1 = mix(vec2(-0.25, 0.25), vec2(0.25, -0.25), prog);
	vec2 c2 = mix(vec2(0.25, 0.25), vec2(-0.25, -0.25), prog2);
	
	if(distance(p, c1) < 0.5/SQRT2){
		val = 1.;
	}
	if(distance(p, c2) < 0.5/SQRT2){
		val = 1.;
	}
	
	if(abs(p.x) + abs(p.y) < 0.5){
		val = 1.;
	}
	
	gl_FragColor = vec4(1., 1.-val, 1.2-val, 1.);
}

float movement(float x){
	float y = fract(x);
	y = clamp(2.*y, 0., 1.) - clamp(2.*y-1., 0., 1.); // Bouncing back & forth
	y = clamp((y - 0.5) * 2.1 + 0.5, 0., 1.); // Clip it
	return y;
}