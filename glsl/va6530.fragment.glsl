// REVISION!!!!1111

// Partycoding @ brbtitan

// Kabuto, Fizzer

// Partially based on someone else's work, just hit "parent"

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define STEP 0.2
#define R_STEP 0.1

#define PI 3.141592653589


float gear(vec2 p){
	//p.x += p.y * 0.15;
	float pyStep = floor(p.y/STEP*2.-.001);
	p.y += step(mod(p.x+.8+pyStep*.5, 2.*PI/5.) + mod(p.x+pyStep*.7, 2.*PI/4.) - mod(pyStep, 1.3731)   , R_STEP * 0.4) * STEP * 0.2;
	
	return step(mod(p.y, STEP),STEP*.5);
}

float color(vec2 p){
	return gear(p);// + grid(p);	
}


vec2 transform(vec2 p){
	float r = length(p);
	float y = -log(length(p))*.5 + time * .2;
	return vec2(atan(p.y, p.x) + time * 0.1 * (fract(floor(y/STEP+.4)*.61)-.5)*1.7, y);
}

void main( void ) {

	vec2 pos = (gl_FragCoord.xy  - resolution*.5) / resolution.x * 10. ;

	float grey = 1.-smoothstep(30.,60.,length(pos)*resolution.x);
	gl_FragColor = vec4(color(transform(pos))*(1.-grey)+grey*.7);

}