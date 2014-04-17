#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void
main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.x * 30.0;
	float c;

	p = vec2( mod(p.x, 2.0), 1 );
	c = float(p.x < 1.0);
	gl_FragColor = vec4(c,c,c,1.0)*0.3;
}