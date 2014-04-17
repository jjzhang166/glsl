#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dots(vec2 pos)
{
	return step(0.1, fract(pos.x * resolution.x / 20.0 + sin(time * gl_FragCoord.x)));
	//+ step(0.8, fract(pos.y * resolution.y / 100.0 * sin(time)))
}

vec2 distort1(vec2 pos)
{
	return vec2(sin(pos.y * 10.0 + (time)) * 0.005 + pos.x, sin(pos.x * 10.0 + (time)) * 0.005 + pos.y);
}

void main( void )
{
	vec2 position = (gl_FragCoord.xy / resolution.xy - vec2(0.5)) * 2.0;
	gl_FragColor = vec4( vec3(dots(position.xy)), 1.0 );
}