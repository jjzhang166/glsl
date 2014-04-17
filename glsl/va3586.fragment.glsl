/* 
 A small sphere tracing test with a light source.
*/
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

#define NUM 3
#define INTERATIONS 50
#define RAY_MISS vec4(0,0,0,0)

struct Sphere
{
	vec3 p;
	float r;
	vec4 c;
};
	
Sphere s[NUM];


// Distance to nearest object
vec2 dtno(vec3 p)
{
	float d = 10000000.0;
	int o;
	for(int i = 0; i < NUM; i++)
	{
		float d2 = distance(p, s[i].p) - s[i].r;
		if(d2 < d)
		{
			d = d2;
			o = i;
		}
	}

	return vec2(d, float(o));
}

vec4 trace_ray(vec3 position, vec3 direction)
{
	float dist;
	for(int i = 0; i < INTERATIONS; i++)
	{
		vec2 d = dtno(position);
		dist = d.x;
		int o = int(d.y);
		if(dist > 0.001)
			position += (direction * dist);
		else
			return vec4(position, o);
	}

	return RAY_MISS;
}

void main()
{	
	vec3 position, direction, n, p;
	vec4 c = vec4(0,0,0,0);
	vec3 light = vec3(resolution.x/2.0+200.0*cos(3.0*time), resolution.y/2.0+200.0*sin(time), 0);
	float cosa;
	//int obr=0;
		
	s[0] = Sphere(vec3(resolution.x/2.0-50.0,resolution.y/2.0+20.0, 180), 25.0, vec4(1.0,0,0,0));
	s[1] = Sphere(vec3(resolution.x/2.0,resolution.y/2.0, 190), 50.0, vec4(0,1.0,0,0));
	s[2] = Sphere(vec3(resolution.x/2.0,resolution.y/2.0-70.0, 200), 100.0, vec4(0,0,1.0,0));
	
	position = vec3(gl_FragCoord.xy, 0);
	direction = vec3(0,0,1);
	vec4 v = trace_ray(position, direction);
	p = v.xyz;

	if(v != RAY_MISS)
	{
		float eps = 0.1;
		vec3 dx, dy;
		dx = trace_ray(position + vec3(1,0,0)*eps, direction).xyz - p;
		dy = trace_ray(position + vec3(0,1,0)*eps, direction).xyz - p;
		n = normalize(cross(dy, dx));
		vec3 reflection = (light - p) - 2.0 * dot(light - p, n) * n;
		cosa = dot(direction, reflection) / (length(direction) * length(reflection));
		
		if(v.w == 0.0)
			c = s[0].c * cosa;
		if(v.w == 1.0)
			c = s[1].c * cosa;
		if(v.w == 2.0)
			c = s[2].c * cosa;
	}
	
			
	for(int i = 0; i < NUM; i++)
	{
		if(length(s[i].p.xy - gl_FragCoord.xy) < 2.0)
			c = vec4(1,0,0,0);
	}

	if(length(light.xy - gl_FragCoord.xy) < 2.0)
		c = vec4(1,1,0,0);

	gl_FragColor = c;
}
