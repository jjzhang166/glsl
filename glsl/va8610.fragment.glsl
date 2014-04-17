#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//mromgwtf
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	float o = 0.0;
	for(int i = 0; i < 5; i++)
	{
		o += (sin(dot(p, vec2(o - 10.0, o + 10.0))))*0.2;
		p.x += 5.0 + sin(p.x) *0.1;
		p.y += 5.0 + sin(p.y) *0.2;
		o = abs(o -0.67);
		o *= 1.1;
		p.x += sin(time *0.08);
		p.y += cos(time * 0.07);
	}
	o*=1.1;
	gl_FragColor = vec4( vec3( mix(0.0, 1.0, o * 0.5), mix(0.00, 1.0, o * 0.56), mix(0.0, 1.0, o * 0.7)), 1.0 );
}