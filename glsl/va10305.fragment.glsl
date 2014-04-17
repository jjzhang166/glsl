#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const float RADIUS = 100.;

float addCircle(vec2 v, float rad)
{
	return 1. - clamp(0., 1., 0.2 * abs(rad - distance(gl_FragCoord.xy, v)));
}

void main(void)
{
	vec2 center = .5*resolution;
	float rad = (sin(time) + 1.0) * 50.;
	float d = addCircle(center, rad) + addCircle(center, rad * 2.) + addCircle(center, rad * 3.) + addCircle(center, rad * 4.) + addCircle(center, 0.);
	d += (1.);
	//float d = gl_FragCoord.x;
	
	//float w = abs(d - RADIUS);
	
	//float c = w < THICK ? .5*(1. + cos(w*PI/THICK)) : 0.;
	
	//gl_FragColor = vec4(d, d, d, 1);
	gl_FragColor = vec4(0, 0, 0, 1);
}