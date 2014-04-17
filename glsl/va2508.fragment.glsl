#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 centre, float rad)
{
	vec2 aspect = vec2(resolution.x/resolution.y, 1.0);
	float c = length(aspect*((gl_FragCoord.xy/resolution.xy) - centre)) / rad;
	c = pow(c, 10.0);
	return 1.0-c;
}

void main( void ) 
{
	
	float m = sin(time) * 0.5;
	//m = cos(time* 13.0) * sin(time*24.5) * sin(time*1.45);
	
	float c = circle(vec2(0.5) + vec2(m, 0.0) * 0.1, 0.2);
	
	
	vec2 centre = gl_FragCoord.xy - resolution.xy * 0.5;
	centre /= resolution;
	
	float y = centre.y / resolution.y;
	float x = centre.x / resolution.x;
	
	//float centre = gl_FragCoord - resolution * 0.5;
	float d = length(centre.xy);
	float angle = atan(y/x);
	angle = acos(x/d);
	
//	angle += d;
	
	x = d * cos(angle*d);
	y = d * sin(angle*d);
	
	c = cos(y*100.0)*sin(time-y-cos(x*30.0));
	
	c *= cos(x* 100.0);

	//c = angle;

	c += 1.0;
	c /= 2.0;
	
	//c=d;
	
	gl_FragColor = vec4(c, c, c, 1.0);
}