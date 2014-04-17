//@ME

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float thing(vec2 pos) 
{
	vec2 p = vec2(pos);
	p.x = mod(sin (p.x)*TWOPI, TWOPI * 2.);
	p.y = fract(cos(p.y)*TWOPI);
	float c = distance(sin(p.y/PI), cos(p.x*(0.22+sin(time)*0.1)));
	float d = sqrt(p.x*p.y) * sqrt(c * p.x);
	return d + exp (c / p.y) + d;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.-5.;
	world.x *= resolution.x / resolution.y;
	float dist = 1./thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
