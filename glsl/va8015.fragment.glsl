#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand();
vec2 seed = vec2(0.431, 0.6313);
float baserand()
{
	float f = (sin(dot(seed,vec2(12.9898,78.233))) * 43758.5453);
	return fract(f);
}
void moverand()
{
	seed.x = baserand();
	seed.y = baserand();
}
float rand()
{
	float f = baserand();
	moverand();
	return f;
}

const int NUM = 8;
vec2 points[NUM];
void main( void )
{
	for(int i=0; i<NUM; ++i)
	{
		points[i] = vec2(rand()/3. * (rand()<0.5 ? 1. : -1.),rand()/3. * (rand()<0.5 ? 1. : -1.));
	}

	vec2 position = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.yy;
	
	vec3 color = vec3(0.0,0.0,0.0);
	for(int i=0; i<NUM; ++i)
	{
		float dist = length(position - points[i]);
		dist = dist/0.07;
		dist = sqrt(sqrt(dist));
		dist = max(dist,0.0);
		dist = min(dist,1.0);
		dist = 1.0-dist;
		color += 4.*abs(sin(4.*time*rand()))*vec3(rand()*dist, rand()*dist, rand()*dist);
	}
			
	gl_FragColor = vec4(color, 1.0);

}