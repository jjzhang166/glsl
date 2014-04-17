#ifdef GL_ES
precision mediump float;
#endif

uniform float 	time;
uniform vec2 	mouse;
uniform vec2 	resolution;

const vec3	LightPos		= vec3(1.2,0.0,1.0);
const vec3	DiffuseColor		= vec3(1.0,235.0/255.0,152.0/255.0);

const float 	MinimumDistance 	= 0.001;
const float	DiffusePower		= 1.0;


const int 	Iterations 		= 14;
const int 	MaximumRaySteps 	= 70;

vec4 qPow(vec4 a)
{
	return vec4(a.x*a.x - a.y*a.y - a.z*a.z - a.w*a.w,
		    2.0*a.x*a.y, 2.0*a.x*a.z, 2.0*a.x*a.w);
}

vec4 qProd(vec4 a, vec4 b)
{
	return vec4(a.x*b.x - a.y*b.y - a.z*b.z - a.w*b.w,
		    a.x*b.y + a.y*b.x + a.z*b.w - a.w*b.z,
		    a.x*b.z - a.y*b.w + a.z*b.x + a.x*b.y,
		    a.x*b.w + a.y*b.z - a.z*b.y + a.w*b.x);
}

float DE(vec3 i)
{
	vec4 q 		= vec4(i, 0.5-abs(sin(time/5.0)/2.0));	// z_0
	vec4 c 		= vec4(-1,0.2+cos(time/2.0)/2.0,0,0);
	vec4 z 		= qPow(q) + c; 				// z_1
	vec4 zdiff 	= 2.0*q;				// z'_1 = 2* z_0 * z'_0
	float len;
	
	for(int i = 0; i<Iterations; i++)
	{
		zdiff 	= 2.0*qProd(z,zdiff);
		z	= qPow(z) + c;
		if (length(zdiff) > 10000000.0) break;
	}
	
	return log(length(z)) * length(z) / (2.0*length(zdiff));
}

vec3 calcNormal(vec3 pos3D)
{
	vec3 eps = vec3(0.001,0.0,0.0);
	return normalize(vec3(DE(pos3D+eps.xyy)-DE(pos3D-eps.xyy),
		              DE(pos3D+eps.yxy)-DE(pos3D-eps.yxy),
		              DE(pos3D+eps.yyx)-DE(pos3D-eps.yyx)));
}

vec3 trace(vec3 from, vec3 direction) 
{
	float totalDistance = 0.0;
	int s;
	for (int steps=0; steps < MaximumRaySteps; steps++) 
	{
		s = steps;
		vec3 p = from + totalDistance * direction;
		float dist = DE(p);
		totalDistance += dist;
		if (dist < MinimumDistance) break;
	}
	if(s < MaximumRaySteps - 1)
	{
		
		vec3 pos3D 	= from + totalDistance * direction;
		vec3 normal 	= calcNormal(pos3D);
		
		vec3 lightDir	= LightPos - pos3D;
		float dist	= length(lightDir);
		lightDir	= lightDir / dist;
		dist		= dist * dist;
		
		// diffuse
		float intensity	= clamp(dot(normal, lightDir), 0.0, 1.0);
		vec3 diffuse	= intensity * DiffuseColor * DiffusePower / dist;
		
		return diffuse;
		
	} else return vec3(0.0);
}

void main( void ) 
{
	vec2 q = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	q.x *= resolution.x/resolution.y;
	
	vec3 ro = vec3(1.2, 0.0, 1.0);
	vec3 fo = vec3(0.0, 0.0, 0.0);
	vec3 cp = vec3(0.0, 1.0, 0.0);
	vec3 cd = normalize(fo - ro);
	vec3 cy = normalize(cross(cd,cp));
	vec3 cx = normalize(cross(cy,cd));
	vec3 rd = normalize(q.x*cy + q.y*cx + cd);
	
	vec3 col = trace(ro,rd);
	gl_FragColor = vec4(col,1.0);
}