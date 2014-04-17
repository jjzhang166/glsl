#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;
float maxd = 1024.;

float crad = 0.5;

struct Hit
{
	vec3 pos;
	float dist;
	vec3 col;
};
	
Hit minH(Hit h1,Hit h2)
{
	if(h1.dist < h2.dist)
	{
		return h1;
	}
	return h2;
}

//http://gamedev.stackexchange.com/a/18459
Hit box(vec3 lb,vec3 rt,vec3 dir,vec3 org,vec3 col)
{
	vec3 dirfrac;
	
	// r.dir is unit direction vector of ray
	dirfrac.x = 1.0 / dir.x;
	dirfrac.y = 1.0 / dir.y;
	dirfrac.z = 1.0 / dir.z;
	// lb is the corner of AABB with minimal coordinates - left bottom, rt is maximal corner
	// r.org is origin of ray
	float t1 = (lb.x - org.x)*dirfrac.x;
	float t2 = (rt.x - org.x)*dirfrac.x;
	float t3 = (lb.y - org.y)*dirfrac.y;
	float t4 = (rt.y - org.y)*dirfrac.y;
	float t5 = (lb.z - org.z)*dirfrac.z;
	float t6 = (rt.z - org.z)*dirfrac.z;

	float tmin = max(max(min(t1, t2), min(t3, t4)), min(t5, t6));
	float tmax = min(min(max(t1, t2), max(t3, t4)), max(t5, t6));

	float t;
	// if tmax < 0, ray (line) is intersecting AABB, but whole AABB is behing us
	if (tmax < 0.0)
	{
		t = tmax;
		return Hit(vec3(0),maxd,vec3(0));
	}

	// if tmin > tmax, ray doesn't intersect AABB
	if (tmin > tmax)
	{
		t = tmax;
		return Hit(vec3(0),maxd,vec3(0));
	}

	t = tmin;
	
	return Hit(vec3(dir*t),t,col);
}

vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return v*rxmat*rymat;
	
}


vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {

	vec2 p = (( gl_FragCoord.xy / resolution.xy )-.5)*2.;
	
	vec3 orig = vec3(cos(time),0.6,sin(time))*10.;//vec3(cos(time),2.,sin(time))*2.;
	vec2 look = vec2(time+(pi*.5),0.3);
	
	vec3 color = vec3(0.0);
	
	vec3 dir = (vec3(p,1.));
	
	dir = rotate(dir,look);

	Hit f = Hit(vec3(0),maxd,vec3(0.5));
	
	for(float x = -4.;x <= 4.;x++)
	{
		for(float y = -4.;y <= 4.;y++)
		{
			vec3 bp = vec3(x,0.,y);
			float h = sin(length(bp)-time)+1.;
			
			vec3 lb = vec3(bp.x-crad, -crad, bp.z-crad);
			vec3 rt = vec3(bp.x+crad, h, bp.z+crad);
			
			f = minH(f,box(lb,rt,dir,orig,hsv2rgb(length(bp.xz/8.),0.75,1.)));
		}
	}
	
	
	color = f.col*vec3(-f.pos.y*0.125);
		
	gl_FragColor = vec4( color , 1.0 );

}