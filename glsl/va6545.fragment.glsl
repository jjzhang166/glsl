
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define STEP 1.0

#define PI 3.41

float color(vec2 p){
	
	float pyStep = floor(p.y/2.0);
	return step(mod(p.y, STEP),STEP*.5);	
}


vec2 transform(vec2 p){
	float r = length(p);
	float y = -log(length(p))*.5 + time * .2;
	return vec2(atan(p.y, p.x) + time * 0.1 * (fract(floor(y/STEP+.4)*.61)-.5)*1.7, y);
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy ;

	gl_FragColor = vec4(color(pos));

}