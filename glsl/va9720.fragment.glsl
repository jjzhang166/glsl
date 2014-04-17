#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// modified by @hintz 2013-06-29 #RadioHack

void main(void) 
{
	float r;
	float g;
	float b;

	r = cos(time - gl_FragCoord.x / 128.1);
	r += sin(time*1.1 + gl_FragCoord.y / 28.2);
	g = r;
	r += sin(- time*1.2 + (gl_FragCoord.y - gl_FragCoord.x) / 28.3);
	b = r;
	r += sin(sqrt(gl_FragCoord.y * gl_FragCoord.y + gl_FragCoord.x*gl_FragCoord.x) / 28.4);
	vec4 color = normalize(vec4(r, g*r, b*r, 1.0));
	
	gl_FragColor = color;
}