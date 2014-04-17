// i'll get them hexagoms one day
// this is proper ugly
// @M
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float
rand(float x)
{
	return mod(sin(x*119.)*79., 1.);
}

float
hex(vec2 p)
{
	vec2 r, q;
	
	p = p / vec2(sqrt(3.)/2., 1.5);
	r = floor(p);
	p = vec2(abs(mod(p.x+r.y, 2.)-1.), mod(p.y, 1.));
	if(p.x/3. - p.y > 0.)
		r.y--;
	r.x = floor((r.x+mod(r.y,2.))/2.);
	float a = rand(r.x*17.+r.y);
	return (a > .5 ? a : 0.);
}

float
square(vec2 p)
{
	vec2 r, e;
	float ul, ur, ll, lr;
	e = vec2(0., 1.);
	r = floor(p);
	ul = hex(r+e.xx);
	ur = hex(r+e.yx);
	ll = hex(r+e.xy);
	lr = hex(r+e.yy);
	if(ul == 0. && ur == 0. && ll == 0. && lr == 0.)		
		return rand(r.x*17.+r.y)*.5+.5;
	return hex(p);
}

void
main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.x + vec2(sin(abs(mod(time, 2.)-1.)*sin(time/2.)/4.), sin(time/2.)*sin(time/15.));
	float c = 0.;
	c = square(p*20.);
	gl_FragColor = vec4(c, c, c, 1.);
}