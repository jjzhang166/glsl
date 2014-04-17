#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float plane(vec3 pi, vec2 pt)
{
	return dot(pi.xy, pt) - pi.z;	
}

float C0(vec3 pi0, vec3 pi1, vec2 pt)
{
	return (1.0-pt.x)*plane(pi0,pt) + pt.x*plane(pi1,pt);
}

float C1(vec3 pi0, vec3 pi1, vec2 pt)
{
	//return pow(1.0-pt.x,2.0)*plane(pi0,pt) + 2.0*(1.0-pt.x)*pt.x*C0(pi0,pi1,pt) + pt.x*pt.x*plane(pi1,pt);
	return pow(1.0-pt.x,2.0)*plane(pi0,pt) + 2.0*(1.0-pt.x)*pt.x*pt.y + pt.x*pt.x*plane(pi1,pt);
}

float C2(vec3 pi0, vec3 pi1, vec2 pt)
{
	//return pow(1.0-pt.x,3.0)*plane(pi0,pt) + 3.0*(1.0-pt.x)*pt.x*C1(pi0,pi1,pt) + pow(pt.x,3.0)*plane(pi1,pt);
	return pow(1.0-pt.x,3.0)*plane(pi0,pt) + 3.0*(1.0-pt.x)*pt.x*pt.y + pow(pt.x,3.0)*plane(pi1,pt);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / min(resolution.x, resolution.y) );
	if (position.x > 1.0 || position.y > 1.0) discard;
	
	position.y -= 0.25;
	vec3 plane0 = vec3(cos(time), sin(time), 0.0);
	vec3 plane1 = vec3( 1.0, 1.0, 1.0);
	float sum = C1(plane0, plane1, position);
	if (sum < 0.0)
	{
		sum = -sum;
	}
	
	vec4 base = vec4(0.0, 0.5, 0.0, 0.0);
	vec4 filter = vec4(1.0, 0.0, 0.0, 1.0);
	float base_x = plane(plane1, position); 
	if (base_x < 0.0)
	{
		base *= 0.0;	
		filter = vec4(0.0, 0.0, 1.0, 1.0);
	}
	vec4 color = vec4(vec3(pow(1.0-sum,100.0)), 1.0) * filter + base;
	gl_FragColor = color;
}