// trying to figure out how to do the hex() function
// @M

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float
color(vec2 p)
{
	float k;
	vec2 s = vec2(sqrt(3.)/2., 1.5);

	p = abs(mod(p, 2.*s)-s); 
	k = p.x*.5 - (p.y-.5)*sqrt(3.)/2.;
	if(k < 0.)
		p = p+2.*(s/2.-p);
	return min(abs(k), p.x);	
}

void
main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.x;
	float c = 0.;
	p *= 20.0; // scale
	c = step((cos(time)+1.)*0.1, color(p));
	//c = color(p);
	gl_FragColor = vec4(c, c, c, 1.);
}