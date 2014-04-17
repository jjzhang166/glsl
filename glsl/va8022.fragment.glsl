#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand();
vec2 seed = vec2(0.123, 0.613);
float rand() 
{
	float f = (cos(dot(seed ,vec2(21.3898,78.233))) * 43758.5453);
	seed.x = fract(f);
	return fract(f);
}

const int NUM = 64;
float grad[NUM];
void main( void )
{
	for(int i=0; i<NUM; ++i)
	{
		grad[i] = rand() - 0.5;
	}

	vec2 position = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.yy;
	
	vec3 color = vec3(0.0,0.0,0.0);
	for(int i=0; i<NUM; ++i)
	{
		float dist = length(position - vec2(grad[i], 0.0));
		dist = dist/0.07;
		dist = sqrt(sqrt(dist));
		dist = max(dist,0.0);
		dist = min(dist,1.0);
		dist = 1.0-dist;
		color += 4.*abs(sin(4.*time*rand()))*vec3(0.25*dist, 0.45*dist, dist);
	}
			
	gl_FragColor = vec4(color, 1.0);

}