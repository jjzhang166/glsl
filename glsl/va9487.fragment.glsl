#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define SQRT2 1.4142

#define TIMESCALE 0.4

// polar mod

float movement(float x);

void main( void ) {
	//vec2 g = (gl_FragCoord.xy / resolution.xy);
	
	vec2 g = vec2(gl_FragCoord.x/resolution.x*(3.14159*2.), gl_FragCoord.y/resolution.y);
	
	//g.y += 1.;
	//g.x /= 3.14;
	
	vec2 p = vec2(cos(g.x)*g.y, sin(g.x)*g.y);
	
	float val = 0.;
	
	float prog = movement(time * TIMESCALE);
	float prog2 = movement(time * TIMESCALE + 0.25);
	
	vec2 c1 = mix(vec2(-0.45, 0.25), vec2(0.25, -0.25), prog);
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