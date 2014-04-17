#ifdef GL_ES
precision highp float;
#endif
//anony_gt
//mod @ToBSn
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;


float thing(vec2 pos) 
{
	float ret = 0.0;
	pos.x = cos(pos.x / 0.14) * sin(time * 0.5) / tan(pos.y) * tan(pos.x);
	pos.y = sin(pos.y * 0.14) + length(pos+time) - distance(pos.y,pos.x);
	ret = min(pos.x + pos.y + sin(time * 0.1), pos.x) - cos(time);
	return ret;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = (position - mouse)*30.;
	world.x *= resolution.x / resolution.y;
	float dist = thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );


}