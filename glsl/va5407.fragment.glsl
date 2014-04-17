#ifdef GL_ES
precision mediump float;
#endif

//real motion blur
//MrOMGWTF

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 m;
vec2 orp;

#define ITERS 8

vec3 getcolor(vec2 pos)
{
	vec3 c = vec3(0.0, 0.5, 1.0);
	
	c += 1.0 / length(orp) * 0.3;
	
	if(distance(vec2(sin(time * 6.0), cos(time * 6.0) * 0.6), pos) < 0.1)
	{
		c = vec3(0.0, 0.0, 0.3);
	}
	
	return c;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	float aspect = resolution.x / resolution.y;
	m = mouse;
	m = m * 2.0 - 1.0;
	position.x *= aspect;
	m.x *= aspect;
	orp = position;
	
	vec3 color = vec3(0.0);
	vec2 incr = normalize(vec2(sin(time * 6.0 + 0.01), cos(time * 6.0 + 0.01) * 0.6) - vec2(sin(time * 6.0), cos(time * 6.0) * 0.6));
	
	for(int i = 0; i < ITERS; i++)
	{
		color += getcolor(position);
		position = position + incr * 0.02;
	}
	
	color /= float(ITERS);
	
	color *= 1.3 - length(orp) * 0.6;
	
	color = pow(color, vec3(0.9, 1.2, 1.3));
	
	color += vec3(0.0, 0.05, 0.1);
	
	color *= 1.0;
	
	if(abs(orp.y) < 0.8)
	
	gl_FragColor = vec4( color, 1.0 );

}