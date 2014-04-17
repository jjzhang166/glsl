#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand()
{
	//vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 pos = mouse.xy;
	float r = 0.5 * (pos.x + pos.y);
	float s = 0.5 * (pos.y - pos.x + 1.0);
	const float mr = 1.0e-3;
	const float ms = 1.0e-3;
	const float rmr = 1.0 / mr;
	const float rms = 1.0 / ms;
	
	float rm = mod(r, mr) * rmr;
	float rs = 1.0 - mod(s, ms) * rms;
	
	float com = 0.5 * (rm + rs);
	
	return com;
}

void main()
{
	
	float r = rand();
	
	gl_FragColor = vec4(r);
	
}