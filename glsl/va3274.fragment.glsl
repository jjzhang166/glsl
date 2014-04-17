//@ME
//Wanna see more nice HQ patterns here!

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

float unsin(float t)
{
	return sin(t)*0.5+0.5;
}

float thing(vec2 pos) 
{
	float a = clamp(cos(pos.y) + sqrt(5.+cos(pos.x)), 0., 5.) + unsin(pos.x*.5) * unsin(pos.y*3.);
	float b = clamp((tan(pos.y)-0.5) * sqrt(5.+cos(pos.x)), 0., 1.);
	return a - b;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 80.0;
	world.x *= resolution.x / resolution.y;
	float dist = 0.5/thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}