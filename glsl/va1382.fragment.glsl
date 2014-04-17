#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float
smoothstep(float x)
{
	if(x < 0.0)
		return 0.0;
	if(x > 1.0)
		return 1.0;
	return x*x*(3.0-2.0*x);
}

float
smoothmix(float a, float b, float d, float r)
{
	return mix(a, b, smoothstep((d + r/2.0)/r));
}

void
main(void)
{
	float f = 4.0;
	vec2 pos = (gl_FragCoord.xy - resolution.xy / 2.0) * 2.0 / resolution.x * f;
	vec2 mpos = (mouse.xy - .5) * resolution.xy * 2.0 / resolution.x * f;
	float a = 3.14159;
	vec3 p = vec3(pos - mpos, time);;
	//float d = p.x*p.x+p.y*p.y*p.y+sin(p.z);
	float d = cos(p.x+a*p.y)+cos(p.x-a*p.y)+cos(p.y+a*p.z)+cos(p.y-a*p.z)+cos(p.z-a*p.x)+cos(p.z+a*p.x);
	gl_FragColor = vec4(d,d,d,1.0);
}