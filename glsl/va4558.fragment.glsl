#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 coord = (-1.0 + 2.0 * gl_FragCoord.xy);
	coord.x /= resolution.x / resolution.y;
	coord.y /= resolution.x / resolution.y;

	
	// experiment here
	vec3 col= vec3(sin(time));
        col.g += sin(log(coord.x/10.));
	col.g += cos(log(coord.y/3.));
	col.g += abs(cos(sin(time) * log(1.-coord.x/4.)));	
	
	col.r = 1. - sin(log(coord.x/10.));
	col.r = 1. - cos(log(coord.y/3.));
	col.r = 1. - abs(cos(sin(time) * log(1.-coord.x/4.)));
	
	gl_FragColor = vec4(col, 1.0);
}