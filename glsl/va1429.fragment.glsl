#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926
#define ANG (2.0*PI/15.0)

uniform vec2 resolution;

void
main(void)
{
	vec2 r = gl_FragCoord.xy / resolution.y - vec2(.5, .5);
	float c = float(mod(atan(r.y, r.x), ANG) >= ANG/2.0 && length(r) > .3);
	gl_FragColor = vec4(.742, 0, .148, 1) + c*vec4(.268, 1, .852, 1);
}
