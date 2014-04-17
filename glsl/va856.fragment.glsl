#ifdef GL_ES
precision highp float;
#endif
//anony_gt
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;


float thing(vec2 pos) 
{
	pos.x=cos(pos.x*3.14);
	pos.y=sin(pos.y*3.14);
	//pos = max(abs(pos) - 0.7, 0.0);
	//pos = abs(pos);

	return (max(pos.x-pos.y*0.57735,pos.y)-.1);
	//return length(pos) - 1.0;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = (position - mouse) * 5.0;
	world.x *= resolution.x / resolution.y;
	float dist = thing(world)-.6;

	gl_FragColor = vec4( dist, dist*(sin(time*5.)-5.)-.5, dist*(cos(time*.5)) + .25, 1.0 );

	if (abs(dist) < 0.1) 
	{
		gl_FragColor.rgb = vec3(1.0 - abs(dist * 20.0));
	}
}