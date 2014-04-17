#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	vec2 ps = fract(p*5.)-.5; 
	ps /= cos(time * .1); 
	ps *= ps;
	ps *= ps;
	ps *= ps;
	float pn = ps.x + ps.y;
	pn =sqrt(pn);
	pn =sqrt(pn);
	pn =sqrt(pn);	

	float s = abs(pn-0.5);
	float l = 1. - clamp(s/2., 0., .3)/.1;
	
	gl_FragColor = vec4(l);

}