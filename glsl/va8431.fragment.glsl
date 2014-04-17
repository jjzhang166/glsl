precision mediump float;

float iGlobalTime = 0.0;
vec3 iResolution = vec3(800,640,0);

#define MAX_REFLECTIONS 2
#define MAX_MARCHES 20
#define MARCH_BIAS 0.99
#define MIN_DIST 0.01
#define EPS 0.01

#define time iGlobalTime

struct light_data
{	
	vec4 color;
	vec3 pos;
	vec3 att;
};

struct mat_data
{
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	float shininess;
	float reflectiveness;
};

struct ray
{
	vec3 pos;
	vec3 dir;
	vec3 dist;
	
	int reflections;
};

light_data lights[2];
const int num_lights = 2;

void initLights()
{
lights[0].color = vec4(0.8,0.2,0.0,1.0);
lights[1].color = vec4(0.2,0.0,0.8,1.0);

lights[0].pos = vec3(-1,1,0);
lights[1].pos = vec3(0.5,-0.5,0);

lights[0].att = vec3(0,1,0);
lights[1].att = vec3(0,1,0);
}

mat_data c_mat;
void initMat ()
{
c_mat.ambient = 0.3*vec4(1,1,1,1);
c_mat.diffuse = 0.4*vec4(1,1,1,1);
c_mat.specular = 0.2*vec4(1,1,1,1);
c_mat.shininess = 10.0;
c_mat.reflectiveness = 0.3;
}

mat_data getMaterial(in vec3 pos)
{
	return c_mat;
}

vec4 getDiffSpec (vec3 pos, vec3 n, mat_data mat)
{
	vec4 diffspec = vec4(0,0,0,0);
	for(int i=0; i<num_lights; i++)
	{
		float dist = length(lights[i].pos-pos);
		float att_factor = dot(vec3(dist*dist,dist,1),lights[i].att);
		vec3 s2l = normalize(lights[i].pos-pos);
		vec3 hsv = normalize(s2l-pos);
		diffspec+= (mat.diffuse*max(0.0,dot(s2l,n)) 
			+ mat.specular*pow(max(0.0,dot(hsv,n)),mat.shininess))/att_factor;
		
	}
	return diffspec;
}

vec3 rotateY (vec3 pos, float rad)
{
	pos.xz = vec2(cos(rad)*pos.x-sin(rad)*pos.z,sin(rad)*pos.x+cos(rad)*pos.y);
	return pos;
}

float scene (in vec3 pos)
{
	return abs(length(mod(pos,1.0)+vec3(0.5,0.5,0.5))-0.2);
}

float viewscene (in vec3 pos)
{
	return scene(rotateY(pos, time)+vec3(0,0,time));
}

vec3 getNormal (in vec3 pos)
{
	vec2 eps = vec2(EPS, -EPS);
	vec3 n = viewscene(pos+eps.xyy) * eps.xyy
		+ viewscene(pos+eps.yxy) * eps.yxy
		+ viewscene(pos+eps.yyx) * eps.yyx
		+ viewscene(pos+eps.xxx) * eps.xxx;
	return normalize(n);
}


bool raymarch (inout ray r)
{
	bool hit = false;
	for(int i=0; i<MAX_MARCHES; i++)
	{
		float step = viewscene(r.pos+r.dist*r.dir);
		r.dist += step;
		if (step < MIN_DIST && i!=0)
		{
			hit = true;
			break;
		}
	}
	r.dist*=MARCH_BIAS;
	return hit;
}

void reflect_ray (inout ray r, vec3 n)
{
	r.pos = r.pos + r.dist*r.dir;
	r.dir = reflect(r.dir,n);
}
	
vec4 render (inout ray r)
{
	vec4 ambient = vec4(1,1,1,1);
	vec4 result = vec4(0,0,0,0);
	
	for (int i=0; i<MAX_REFLECTIONS; i++)
	{
		if(!raymarch(r))
		{
			break;
		}
		vec3 normal = getNormal(r.pos);
		mat_data mat = getMaterial(r.pos);
		vec4 diffspec = getDiffSpec (r.pos, normal, mat);
		result += ambient*diffspec;
		ambient *= mat.reflectiveness*mat.ambient;
		
		if(mat.reflectiveness==0.0)
		{
			break;
		}
		reflect_ray(r, normal);
	}
	return result;
}

vec3 getDir (vec2 loc, float fov)
{
	return vec3(loc,0.5/tan(0.5*fov));
}

vec2 center (vec2 v)
{
	v /= iResolution.xy;
	v.x *= iResolution.x/iResolution.y;
	return v;
}

vec4 render ()
{
	vec2 loc = center(gl_FragCoord.xy);
	
	ray r;
	r.dir = getDir(loc, 90.0);
	
	return render(r);
}

void main ()
{
	gl_FragColor = render();	
}