/*
	By @Stv
	Example taken from @gigahole live coding
	http://www.youtube.com/watch?v=eRuTRs3hxfc
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{

	vec2 p = 1.0 - 2.0 + gl_FragCoord.xy / resolution.xy + mouse;	
	vec2 z = vec2(0.5 + 0.5 * sin(time / 2.0), 0.0);
	int i;
	
	for (int k=0; k<32; k++)
	{
		if (length(z) > 2.0) break;
		
		z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + p;
		
		i = k;
	}
	
	float v = float(i) / 32.0;
	
	gl_FragColor = vec4(v, v * sin(v / 1.23), v / cos(time), 0.0);
}