#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592

// B

float circle(vec2 pos, float r, vec2 pt)
{
	vec2 d = pos - pt;
	return sqrt(d.x * d.x + d.y * d.y) < r ? 1.-pow(sqrt(d.x * d.x + d.y * d.y) / r, 5.) : 0.;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = (abs(sin(time / 2.)) * .9 + .1) * circle(vec2(sin(time) * .3 + .5, sin(time) * .1 + .5), .15, position);
	float g = 0.;
	if((abs(sin(time / 2.)) * .8 + .2) < (abs(cos(time / 2.)) * .8 + .2))
	{
		g = (abs(cos(time / 2.)) * .9 + .1) * circle(vec2(sin(time + PI) * .3 + .5, sin(time + PI) * .1 + .5), .15, position);
		if(g > 0. && r > 0.) r = 0.;
	}
	else
	{
		if(r == 0.)
			g = (abs(cos(time / 2.)) * .8 + .2) * circle(vec2(sin(time + PI) * .3 + .5, sin(time + PI) * .1 + .5), .15, position);
	}
	
	gl_FragColor = vec4( r, g, 0., 1. );

}