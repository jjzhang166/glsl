#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dist(vec2 a, vec2 b)
{
	return sqrt( (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}

void main( void ) 
{	
	vec4 color = vec4(0);
	
	float modf = cos(time) * sin(time) * 100.0 + 250.0;
	
	vec4 upcolor = vec4(0.4, 0.8, 0.4, 0);
	vec4 rightcolor = vec4(0.3, 0.1, 0.4, 0.8);
	
	vec2 center = vec2(100.0 * sin(time), 100.0*cos(time));
	vec2 newFragCoord = gl_FragCoord.xy - resolution.xy/2.0;
	
	float d = dist(center, newFragCoord);
	//if(d < 400.0 || (d > 700.0 && d < 900.0))
	if(mod(d, 450.0 - modf + 50.0) < modf/2.0)
	{
		vec2 b = mod(newFragCoord, modf)/modf;
		color = upcolor * b.y * mouse.y + rightcolor * b.x * mouse.x * 1.0;
	}
	else
	{
		color = vec4(sin(time)/10.0 + 0.2, cos(time)/10.0 + 0.2, sin(time) * cos(time)/4.0 + 0.3, 0.9);
	}
	
	gl_FragColor = color;
	
}