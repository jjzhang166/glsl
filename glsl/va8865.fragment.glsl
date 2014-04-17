#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// I couldn't resist playing around with Kali's "Cosmos" shader!
// Made here:- https://www.shadertoy.com/view/Msl3WH
// Adapted it from here:-   https://www.shadertoy.com/view/MssGD8

float tim = (time+0.0) * 20.0;

void main(void)
{
	float s = 0.0, v= 0.0;
	vec2 uv = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	
	float t = tim*0.005;
	uv.x += sin(t)*.3;
	
	float si = sin(t);
	float co = cos(t);
	mat2 rot = mat2(co, si, -si, co);
	uv *= rot;
	
	for (int r = 0; r < 100; r++) 
	{
		vec3 p= vec3(0.3, 0.2, floor(tim) * 0.0008) + s * vec3(uv, 0.2);
		p.z = fract(p.z);
		for (int i=0; i < 11; i++)
		{
			p=abs(p)/dot(p,p) * 2.0 - 1.0;
		}
		v += length(p*p)*max(0.3 - s, 0.0) * .012;
		s += .003;
	}
	gl_FragColor = v * vec4(v * 0.35, 0.7, s * 4.2, 1.0);	
}