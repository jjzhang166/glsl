/*
 * kaliset (http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/)
 * by Piers Haken
 * 
 */

#ifdef GL_ES
precision highp float;
#endif

varying vec2 surfacePosition;

uniform vec2 mouse;
uniform vec2 resolution;
uniform float time;

const int max_iteration = 50;
const float bailout = 70000.;

void main( void )
{
	vec2 c = (.1-mouse) * 2.5 + sin(time/3.);
	vec2 z = surfacePosition*3.;
	
	float total = 0.;
	float m = 0.;
	for (int i = 0; i < max_iteration; ++i)
	{
		float pm = m;
		m = dot(z,z);
		//if (m > bailout)
		//	break;
		z = abs(z)/m + c;
		
		total += exp(-1./abs(m - pm));
	}
	
	total = total / 20.;
	gl_FragColor = vec4(total*1.5,total,total/sin(cos(time/10.)), 1.0);
}