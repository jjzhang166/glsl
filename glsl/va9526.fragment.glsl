#ifdef GL_ES
precision mediump float;
#endif

// improved implementation of the voronoi noise floating around here
// vor() now returns the distances to the closest four feature points
// also made it a fractal in main()

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(float x)
{
	return fract(sin(x) * 43758.5453);
}

float noise(vec3 v)
{
	/*
	vec3 p = floor(x);
	vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	float n = p.x + p.y * 57.0 + p.z*113.0;
	
	float a = hash(n);
	return a;
	*/
	
	// I like this one better :)
	return hash(v.x*57.0 + hash(v.y*113.0) + hash(v.z*63.0));
}

float manhattan(vec3 v)
{
	v = abs(v);
	return v.x + v.y + v.z;
}

float cheby(vec3 v)
{
	v = abs(v);
	return v.x > v.y
	? (v.x > v.z ? v.x : v.z)
	: (v.y > v.z ? v.y : v.z);
}

float someMetric(vec3 v)
{
	float f = 2.0;
	return pow(v.x,f) + pow(v.y,f) + pow(v.z,f);
}

vec4 vor(vec3 v)
{
	vec3 start = floor(v);	
	
	vec4 dist = vec4(999999999.0);
	
	for(int z = -2; z <= 2; z += 1)
	{
		for(int y = -2; y <= 2; y += 1)
		{
			for(int x = -2; x <= 2; x += 1)
			{
				vec3 t = start + vec3(x, y, z);
				vec3 p = t + noise(t) * 1.0;

				float d = manhattan(p - v);
				
				if(d < dist.x) {
					dist.w = dist.z;
					dist.z = dist.y;
					dist.y = dist.x;
					dist.x = d;
				}
				else if(d < dist.y) {					
					dist.w = dist.z;
					dist.z = dist.y;					
					dist.y = d;
				}
				else if(d < dist.z) {
					dist.w = dist.z;
					dist.z = d;
				}
				else if(d < dist.w) {
					dist.w = d;
				}
			}
		}
	}
	
	return dist;
}

void main( void )
{
	vec3 freq = vec3(8.0, 8.0, 0.25);
	
	// correct for aspect ratio
	freq.y *= resolution.y/resolution.x;
	
	vec2 pos = (gl_FragCoord.xy / resolution.xy);
	
	vec3 v;
	
	vec4 d = vec4(0.0);
	
	const float octaves = 3.0;
	
	const float persistence = 0.25;
	
	float amplitude = 1.0;
	
	for(float i = 0.0; i < octaves; i += 1.0)
	{
		v = vec3(pos, time) * freq;
		
		freq.xy *= 2.0; // ignore the z frequency (time)
		
		d += vor( v ) * amplitude;
		
		amplitude *= persistence;
	}
	
	// f3 - f2
	gl_FragColor = vec4( d.z - d.y );

}
