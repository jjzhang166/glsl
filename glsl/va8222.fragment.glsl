#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(float modifier, float uniformity)
{
	float x = 2000.0 + gl_FragCoord.x + 1.0 / modifier;
	float y = 1000.0 + gl_FragCoord.y + time;
	float r = mod(x / (sin(x) + sin(y)), 1.0);
	return pow(r, uniformity);
}

void main(void)
{
	gl_FragColor = vec4(noise(2.0, 2.0), noise(3.0, 2.0), noise(5.0, 2.0), 1.0);
}
