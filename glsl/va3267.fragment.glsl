//@ME
//Wanna see more nice HQ patterns here!

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;


float thing(vec2 pos) 
{
	float ret = 0.;
	float a = clamp(sin(pos.y + /* * */ 15.) + sqrt(10.+tan(pos.x)), 0., 15.);
	float b = clamp(cos(pos.x / 15.) + sqrt(10.+tan(pos.y)), 0., 15.);
	return a + b;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 20.0;
	world.x *= resolution.x / resolution.y;
	float dist = 1./thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}