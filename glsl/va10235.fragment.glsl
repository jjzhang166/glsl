#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	
	vec2 centre = vec2(0.5, 0.5);
	
	vec2 p = vec2(0, 0);
	vec2 g = vec2(0, 0);
	
	if (mouse.x < 0.5)
	{
		p.x = centre.x - mouse.x;
		g.x = gl_FragCoord.x / resolution.x;
	}
	else
	{
		p.x = mouse.x - centre.x;
		g.x = 1.0 - (gl_FragCoord.x / resolution.x);
	}
	
	if (mouse.y < 0.5)
	{
		p.y = centre.y - mouse.y;
		g.y = gl_FragCoord.y / resolution.y;
	}
	else
	{
		p.y = mouse.y - centre.y;
		g.y = 1.0 - (gl_FragCoord.y / resolution.y);
	}
	
	gl_FragColor = vec4(vec3(p.x * g.x, p.y * g.y, 0), 1.0);
	//gl_FragColor = vec4(vec3(1.0 - (gl_FragCoord.x / resolution.x), 0, 0), 1.0);
	
}