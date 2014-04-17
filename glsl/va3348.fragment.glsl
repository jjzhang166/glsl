//@ME
//Wanna see more nice HQ patterns here!

//Accidental geometry

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
	float a = clamp(sin(pos.y + /* * */ 15.) + sqrt(10.+tan(pos.x - time)), 0., 15.);
	float b = clamp(cos(pos.x / 15.) - tan((mod(pos.y - sin(0.0),  8.0 + sin(0.0)) * sin(0.0) + mod(pos.x - sin(0.0), 8.0 + sin(0.0)) * cos(time)) * 0.2) + sqrt(10.+tan(pos.y + time)), 0., 15.);
	return a + b;
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 20.0 + vec2(0.0, 0.0 * 2.0);
	world.x *= resolution.x / resolution.y;
	float dist = 1./thing(world)*thing(world + vec2(sin(world.x), (world.y + world.x + time * 2.0) * 0.1))-0.01*thing(world + vec2(sin(mod(world.x, 2.0)), (world.y + world.x + time * 2.0) * 0.1));
	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}