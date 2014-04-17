#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


struct Ray
{
	vec3 origin;
	vec3 direction;
};
struct Sphere
{
	vec3 center;
	float radius;
};

float epsilon = 0.005;
Sphere sph1;

Ray generateRayForPixel(vec2 fragCoord)
{
	
	
	
	Ray r;
	r.origin = vec3(0.0, 0.0, 3.0);
	
	vec2 q = fragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0+q;
	p.x = resolution.x / resolution.y;
	r.direction = normalize(vec3( p, -1.5) );
	
	return r;
}

float sphereDist(Sphere sph, vec3 pos)
{
	return length(sph.center - pos) - sph.radius;
}

float castRay(in Ray r)
{
	float stepped = 0.0;		
	const float maxNbStep = 64.0;
	const float maxDist = 20.0;
	
	
	for(float t = 0.0; t<maxNbStep; t++)
	{
		//if(stepped >= maxDist) return 2.0;
		
		vec3 p = r.origin + stepped*r.direction;
		float dist = sphereDist(sph1, p);
		//if(t == 1.0) return dist;
		if(dist < epsilon)
		{
			return 1.0;
		}
		stepped += dist;
	}
	return 0.0;
}
	
void main( void ) {	
	
	sph1.center = vec3(0, 0, 0);
	sph1.radius = 1.0;
	
	Ray r = generateRayForPixel(gl_FragCoord.xy);
	
	
	vec3 color = vec3(0, 0, 0);
	
	float id = castRay(r);
	if(id == 1.0)
	{
		color = vec3(1,0,0);
	}
	if(id == 2.0)
	{
		color = vec3(0,1,0);
	}
	
	
	gl_FragColor = vec4(color, 1);
	//gl_FragColor = vec4(id / 64.0, 0, 0, 1);
	//gl_FragColor = vec4(r.direction.x, r.direction.y, r.direction.y, 1);

}