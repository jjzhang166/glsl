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

float randvec(vec2 ab) 
{
	float f = (cos(dot(ab.xy ,vec2(21.3898,78.233))) * 43758.5453);
	return fract(f);
}

void main( void )
{
	vec2 offpos = gl_FragCoord.xy + vec2(int(128.0*sin(time)),0.0);
	vec2 pos = (offpos - 0.5 * resolution.xy) / resolution.yy;
	
	float dist = abs(pos.y + randvec(pos)/8.0);
	dist *= 20.0;
	dist -= 2.0*randvec(pos);
	int igrad = int(abs(pos.x)*63.0);
	dist += randvec(vec2(pos.x,0.0));
	
	vec3 color = 1.0 - vec3(cos(pos.x*1.0)*dist, cos(pos.x*1.5)*dist, cos(pos.x*1.75)*dist);		
	gl_FragColor = vec4(color, 1.0);

}