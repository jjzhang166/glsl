#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// just some lava by @hintz 2013-04-20

float squares(float modifier, float uniformity)
{
	float x = 0.02 * gl_FragCoord.x + 0.1*time * modifier;
	float y = 0.02 * gl_FragCoord.y - time + modifier;
	float r = sin((sin(x)+sin(modifier+time+y*x*0.001) + sin(y)));
	return pow(sin(2.0*r), 40.0*uniformity);
}

void main(void)
{
	gl_FragColor = vec4(squares(2.0, 0.1), squares(3.0, 0.2), squares(5.0, 0.3), 1.0);
}
