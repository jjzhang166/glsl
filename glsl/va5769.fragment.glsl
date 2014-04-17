# ifdef GL_ES
precision mediump float;
# endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


void main()
{
	float r;
	r = ((sin(time) / 2.0) + 0.5);
	r *= (-(gl_FragCoord.x / resolution.x) + 1.0);
	
	float g = 0.01;
	float b = 0.01;
	
	gl_FragColor = vec4(r, g, b ,1.0);
}
