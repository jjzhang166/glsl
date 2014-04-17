#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 hall(float x, float y)
{
	
	vec3 l = vec3(0.);
	float a = (x - mouse.x) / (1. -  mouse.x);
	a = max((x - mouse.x) / (-mouse.x), a);
	float b = (y - mouse.y) / (1. - mouse.y);
	b = max((y - mouse.y) / (-mouse.y), b);
	float c = max(a, b);
	if(a > b)
	{
		l.x = a;
	}
	else
	{
		l.z = b;
	}
	return l;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float x = position.x;
	float y = position.y;
	
	vec3 color = hall(x, y);

	gl_FragColor = vec4( color.x, color.y, color.z, 1. );

}