#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float s = 1.;
void line(vec2 a, vec2 b)
{
	if (a.x != b.x && a.y != b.y)
	{
		s = abs((gl_FragCoord.y - a.y)/(b.y - a.y) - (gl_FragCoord.x - a.x)/(b.x - a.x));
		if (gl_FragCoord.x > max (a.x,b.x) || gl_FragCoord.x < min (a.x,b.x) )
			s = 1.;
	}	
}
void main( void )
{	
	vec2 b = vec2(mouse.x*resolution.x,mouse.y*resolution.y);
	vec2 c = vec2(100.,300.);
	line(b,c);
	
	gl_FragColor = vec4(0.01/s, 1.0, mouse.x, 1.);
}