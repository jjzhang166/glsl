//Wubby Screen

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	vec2 ps = fract(cos(p*5.)-sin(p*5.)); 
	ps /= cos(time * 5.0) - sin(time * 5.0); 
	ps *= ps;
	ps *= ps;
	float pn = dot(ps.x,ps.y);
	pn =abs(sqrt(pn * sin(ps.x)));
	pn =abs(sqrt(pn * cos(ps.x))) ;
	pn =abs(sqrt(pn * cos(ps.x)));	

	float s = abs(pn-0.5) * abs(pn-0.5) * abs(pn-0.5) * abs(pn-0.5);
	float l = 1. - clamp(s, 0., .3)/.1;
	
	vec4 col = vec4(abs(sin(time*0.03)),abs(sin(time*0.23)*2.0),abs(sin(time*0.03)),1.0);
	
	gl_FragColor = vec4(l*col);

}