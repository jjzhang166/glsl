#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 circle(vec2 origin, float radius, vec3 color, vec3 original)
{
	vec2 point = gl_FragCoord.xy;
	
	float x = distance(origin,point);
	
	if (x < 0.)
	{
		return original;
	}
	else
	{
		return color;
	}
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec3 color = vec3(0,0,0);
	
	color = circle(vec2(resolution.x*.5,resolution.y*.5),10.,vec3(1.,.0,.0), color);

	gl_FragColor = vec4( color, 1.0 );

}