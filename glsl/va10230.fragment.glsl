#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Leadlight by @hintz 2013-05-02

void main()
{
	vec2 position = gl_FragCoord.xy / resolution.y - 0.5;
	
	float r = length(position);
	float a = atan(position.x - mouse.y, position.y - mouse.x);
	float t = time*mouse.y * 0.002 *(normalize(mouse.y));
	
	float light = 15.0*abs(0.05/(sin(t*t*t)+sin(time*a*0.008)));
	vec3 color = vec3(-sin(r*3.0-a-time+sin(r*t)), sin(r*3.0+a-cos(time)+sin(r+t)), cos(r+a*2.0+log(5.001-(a/2.0))+time)+sin(r/t));
	
	gl_FragColor = vec4((normalize(color)+mouse.x) * light * t, 0.2);
}