#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	vec2 ps = fract(p*10.)-.5; 
	ps /= cos(time * .5); 
	ps *= ps;
	ps *= ps;
	ps *= ps;
	float pn = ps.x + ps.y;
	pn =sqrt(pn);
	pn =sqrt(pn);
	pn =sqrt(pn);	

	float s = abs(pn-0.5);
	float l = 1. - clamp(s/2., 0., .3)/.1;

	
	float actualX = p.x * resolution.x;
	float actualY = p.y * resolution.y;
	
	//vec3 color = s*vec3(1., 0., 0.3);
	//vec3 color = vec3(l*1., 1.*s, 0.3*l) *;
	vec3 color = vec3 (l);
	
	//float dx = floor(mod(((actualX/10.)), 2.));
	//float dy = floor(mod(((actualY/10.)), 2.));
	float dx = ceil(mod(((actualX/10.)), 2.));
	float dy = floor(mod(((actualY/10.)), 2.));
	
	vec3 hue = vec3(1. * abs(cos(time/2.)), 1. * abs((cos(time/7.))), 1. * abs(sin(time/3.)));
	
	color = vec3(dx*dy);
	
	gl_FragColor = vec4((hue*color), 1.);

}