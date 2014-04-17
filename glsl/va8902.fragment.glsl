#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 position = gl_FragCoord.xy / resolution.xy - mouse;
	float t = time;
	float a = atan(position.x, position.y);
	a += t*0.4;
	a = fract(a) + sin(t*2.0)*0.3;
	a = float(a > .2) - float(a < .7);
	gl_FragColor = vec4(a, a, a , .0);
}