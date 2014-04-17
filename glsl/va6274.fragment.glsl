#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// tried to model lorentz transform


float color(vec2 pos, float time) {
	float r = length(pos);
	float w = atan(pos.y,pos.x);
	w = (fract(w/3.14159265*16.+.5)-.5)*r/16.*3.14159265;
	r = fract(r-time)-.5;
	
	return step(w*w+r*r,.1);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy - resolution.xy*.5 )/resolution.x * 40.;

	float a = (mouse.x*2.-1.)*.99;

	p.x -= floor(a*time*.05+.5)*20.;

	
	vec2 l = vec2(p.x,time);
	l *= mat2(1,a,a,1)/sqrt(1.-a*a);
	p.x = l.x;
	
	gl_FragColor = vec4(color(p,l.y));
	
}