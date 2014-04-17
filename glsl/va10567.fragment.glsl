#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

// Leadlight by @hintz 2013-05-02

void main()
{
	vec2 position = gl_FragCoord.xy / 300.0;
	
	float r = length(position);
	float a = atan(position.y, position.x);
	float t = cos(time)+sin(time)+ 10.0/(r+.5);
	
	float light = 20.0*abs(.04/(sin(t)+sin(sin(time)-a*.2)));
	vec3 color = vec3(-sin(r*5.0-a-(time)+sin(r+t)), 
			  sin(r*2.0+a-cos(time)+sin(r+t)), 
			  cos(r+a*5.0+log(5.0-(a/4.0))+time)-sin(r+t));
	
	gl_FragColor = vec4(((color)+.6) * light , 1.0);
}