#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926

uniform vec2 resolution;
uniform float time;

	
float s (float v) { return ( smoothstep(0.0, v, sin(time) )); }

void main(void)
{
	float ANG = ((2.0*PI + cos(time) )/15.0);
	vec2 r = gl_FragCoord.xy / resolution.y - vec2(.5, .5);
	float c = float(mod(atan(r.y, r.x), ANG) >= ANG/2.0 && length(r) > .3);
	gl_FragColor = vec4(.742, 0, .148, 1) + c*vec4( s(.268), s(.5), s(.852), 1);
}