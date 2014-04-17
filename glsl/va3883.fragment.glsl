#ifdef GL_ES
precision mediump float;
#endif

//mod: nnorm

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy  - resolution.xy*.5 ) / resolution.y;
	
	float l = length(position)*3.;
	float a = atan(position.y,position.x);
	a *= sign(fract(l*2.5+1.125)-.5);
	a += time;
	a = a/3.1415926535*floor(l+.9)*3.;

	
	vec2 pos2 = vec2(
		fract(a)-.5,
		fract(l+.5)-.5
	);
	
	pos2 *= mat2(.96,.28,-.28,.96);
	pos2 = abs(pos2);
	float d = max(pos2.x,pos2.y);
	
	float color = l > .5 && fract(l*.5-.25) < .5 && l < 1000.? step(abs(d-0.5-0.5*sin(time)),.4) * sign(fract(a*2.5)-.5) * .5 + .5 : .5;

	gl_FragColor = vec4(vec3(pow(color,.7)),1.);

}