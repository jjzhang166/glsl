#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20120228
// more colors and motion by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rainbow(float x)
{
	x=fract(0.16666 * abs(x));
	if(x>.5) x = 1.0-x;
	if(x<.16666) return 0.0;
	if(x<.33333) return 6.0 * x-1.0;
	return 1.0;
}

void main(void)
{
	vec2 position = ( 1.0*gl_FragCoord.xy  - resolution.xx) / resolution.xx;
	vec3 color = vec3(0.0);

	float r = length(position);
	float a = atan(position.y, position.x);

	float b = a*15.0/3.14159265359;
	color = vec3(rainbow(b+time*0.1), rainbow(b+time*0.201), rainbow(b-time*0.301));

	float t = .5*(1.0 + cos(a + 40.0 * r * (1.0 + sin(a*20.0+time)*.1) - time*3.0) * (5.0 / (r+5.0)));

	gl_FragColor.rgba = vec4(color, 1.0);
}