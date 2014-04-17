#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy  - resolution.xy*.5 ) / resolution.y;
	
	float l = length(position)*20.;
	float a = atan(position.y,position.x);
	a *= sign(fract(l*.25+.125)-.5);
	a += time;
	a = a/3.1415926535*floor(l+.5)*3.;

	
	vec2 pos2 = vec2(
		fract(a)-.5,
		fract(l+.5)-.5
	);
	
	pos2 *= mat2(.96,.28,-.28,.96);
	pos2 = abs(pos2);
	float d = max(pos2.x,pos2.y);
	
	float color = l > 1.5 && fract(l*.5-.25) < .5 && l < 9.5? step(abs(d-.36),.04) * sign(fract(a*.5)-.5) * .5 + .5 : 0.5;

	gl_FragColor = vec4(vec3(pow(color,.7)),1.);

}