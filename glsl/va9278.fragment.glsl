// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Leadlight by @hintz 2013-05-02

void main()
{
	vec2 position = gl_FragCoord.xx / resolution.xy - vec2(1.0, 0.5);
	
	float r = length(position);
	float a = atan(position.y, position.x);
	float t = time + 1.0/(r+1.0);
	
	float light = 9.0*abs(0.05*(sin(t)+sin(time+a*25.0)));
	vec3 color = vec3(-sin(r*5.0-a-time+sin(r+t)), sin(r*3.0+a-time+sin(r+t)), cos(r+a*2.0+a+time)-sin(r+t));

	color.r *= 0.5;
	color.g *= 0.5;
	color.b *= 1.0;
	
//	gl_FragColor = vec4((normalize(color)+0.9) * light , 1.0);

	vec3 fcolor = vec3(((color)+0.9) * light);
	fcolor.r *= 0.9;
	fcolor.g *= 0.3;
	fcolor.b *= 0.8;

	gl_FragColor = vec4(fcolor, 1.0);
}