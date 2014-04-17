#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Leadlight by @hintz 2013-05-02
// Made kaleidoscope-y Tam 2013-05-29

void main()
{
	vec2 position = gl_FragCoord.xy / resolution.xx - mouse;
	
	float r = length(position);
	float a = atan(position.y, position.x);
	float m = mod(time*0.1,2.0);
	m = (m > 1.0) ? 2.0-m : m;
	a *= 1.0+m;
	a = fract(a);
	a = (a > 0.5) ? 1.0-a : a;
	float t = time + 100.0/(r+1.0);
	
	float light = 15.0*abs(0.05*(sin(t)+sin(time+a*10.0)));
	vec3 color = vec3(-sin(r*5.0-a-time+sin(r+t)), sin(r*3.0+a-time+sin(r+t)), cos(r+a*2.0+a+time)-sin(r+t));
	
	gl_FragColor = vec4((normalize(color)+0.9) * light , 1.0);
}