#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;


float thing(vec2 pos) 
{
	float ret = 0.0;
	pos.x = sqrt(pos.x / 2.14) * (sin(time * 0.5) ) / sign(pos.y) * tan(pos.x);
	pos.y = sin(pos.y * 13.14) + sign(pos.x) - sqrt(pos.y/pos.x);
	ret = max((pos.y * sin(time*5.)) + pos.x + sin(time * 0.1), sin(time));
	return ret;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 15.0;
	world.x *= resolution.x / resolution.y;
	float dist = thing(world)*0.06;

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}