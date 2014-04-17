//
// SDF experiments in 2D
// naïve continuous rectangle
//
// Florian Hoenig
// @rianflo
//
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float softmaxf(float a, float b, float k)
{
	return log(exp(k*a)+exp(k*b))/k;
}

float softminf(float a, float b, float k)
{
	return -(log(exp(k*-a)+exp(k*-b))/k);
}

float sdfRect(vec2 p, vec2 a, vec2 b, float k)
{
	return -softminf( softminf( softminf( -a.y+p.y, b.y-p.y, k ), -a.x+p.x, k ), b.x-p.x, k );
}


void main( void ) 
{
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = mouse * 2.0 - 1.0;
	m.x *= resolution.x / resolution.y;
	float tau = mod(time, 5.0)*50.0;
	float sdf = sdfRect(p, vec2(-0.3, -0.5), vec2(0.5, 0.5), tau);
	gl_FragColor = vec4(sdf, (sdf<0.0) ? 0.0 : 1.0, 1.0, 1.0);
}