#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int raytraceDepth = 2;

#if 0
struct Rect {
	float left,top,right,bottom;
	vec4 c;
};

bool isInRect( Rect r,vec2 v )
{
	if( r.left <= v.x && v.x <= r.right &&
		r.top <= v.y && v.y <= r.bottom ){
		return true;
	}
	return false;
}
#endif

struct Ray
{
	vec3 org;
	vec3 dir;
};
struct Sphere
{
	vec3 c;
	float r;
	vec3 col;
};
	
struct Plane
{
	vec3 p;
	vec3 n;
	vec3 col;
};
	
	
struct Cube
{

	vec3 c;
	vec3 h_side;
	vec3 col;
};

struct Intersection
{
	float t;
	vec3 p;     // hit point
	vec3 n;     // normal
	int hit;
	vec3 col;
};


void sphere_intersect(Sphere s,  Ray ray, inout Intersection isect)
{
	// rs = ray.org - sphere.c
	vec3 rs = ray.org - s.c;
	float B = dot(rs, ray.dir);
	float C = dot(rs, rs) - (s.r * s.r);
	float D = B * B - C;

	if (D > 0.0)
	{
		float t = -B - sqrt(D);
		if ( (t > 0.0) && (t < isect.t) )
		{
			isect.t = t;
			isect.hit = 1;

			// calculate normal.
			vec3 p = vec3(ray.org.x + ray.dir.x * t,
			ray.org.y + ray.dir.y * t,
			ray.org.z + ray.dir.z * t);
			vec3 n = p - s.c;
			n = normalize(n);
			isect.n = n;
			isect.p = p;
			isect.col = s.col;
		}
	}
}

void plane_intersect(Plane pl, Ray ray, inout Intersection isect)
{
	//d = -(p . n)
	// t = -(ray.org . n + d) / (ray.dir . n)
	float d = -dot(pl.p, pl.n);
	float v = dot(ray.dir, pl.n);

	if (abs(v) < 1.0e-6)
		return; // the plane is parallel to the ray.

	float t = -(dot(ray.org, pl.n) + d) / v;

	if ( (t > 0.0) && (t < isect.t) )
	{
		isect.hit = 1;
		isect.t   = t;
		isect.n   = pl.n;

		vec3 p = vec3(ray.org.x + t * ray.dir.x,
		ray.org.y + t * ray.dir.y,
		ray.org.z + t * ray.dir.z);
		isect.p = p;
		float offset = 0.2;
		vec3 dp = p + offset;
		
		if ((mod(dp.x, 1.0) > 0.5 && mod(dp.z, 1.0) > 0.5) || (mod(dp.x, 1.0) < 0.5 && mod(dp.z, 1.0) < 0.5))
			isect.col = pl.col;
		else
			isect.col = pl.col * 0.5;
	}
}

void cube_intersect(Cube c,  Ray ray, inout Intersection isect)
{

	vec3 vertex1 = c.c - c.h_side;
	vec3 vertex2 = c.c + c.h_side;
	vec3 ro = ray.org;
	vec3 rd = ray.dir;
	bool inside = false;
	//Check if point is inside the cube
  
	if(ray.org.x > vertex1.x && ray.org.x < vertex2.x && ray.org.y > vertex1.y && ray.org.y < vertex2.y && ray.org.z > vertex1.z && ray.org.z < vertex2.z)
	{
		ro = ro - rd * 100000.0;
		inside = true;
	}

	float t, t1, t2;
	float temp;
	float tFar = 1000000.0;
	float tNear = -10000000.0;

	if(rd.x == 0.0)
	{
		if(!(ro.x >= vertex1.x && ro.x <= vertex2.x))
		return;// -1;
	}
	else
	{
		t1 = (vertex1.x - ro.x) / rd.x;
		t2 = (vertex2.x - ro.x) / rd.x;

		if(t1 > t2)
		{
			temp = t1;
			t1 = t2;
			t2 = temp;
		}
		if(t1 > tNear)
			tNear = t1;
		if(t2 < tFar)
			tFar = t2;
		if(tNear > tFar)
			return;// -1;
		if(tFar < 0.0)
			return;// -1;
	}

	if(rd.y == 0.0)
	{
		if(!(ro.y >= vertex1.y && ro.y <= vertex2.y))
			return;// -1;
	}
	else
	{
		t1 = (vertex1.y - ro.y) / rd.y;
		t2 = (vertex2.y - ro.y) / rd.y;

		if(t1 > t2)
		{
			temp = t1;
			t1 = t2;
			t2 = temp;
		}
		if(t1 > tNear)
			tNear = t1;
		if(t2 < tFar)
			tFar = t2;
		if(tNear > tFar)
			return;// -1;
		if(tFar < 0.0)
			return;// -1;
	}

	if(rd.z == 0.0)
	{
		if(!(ro.z >= vertex1.z && ro.z <= vertex2.z))
		return;// -1;
	}
	else
	{
		t1 = (vertex1.z - ro.z) / rd.z;
		t2 = (vertex2.z - ro.z) / rd.z;

		if(t1 > t2)
		{
			temp = t1;
			t1 = t2;
			t2 = temp;
		}
		if(t1 > tNear)
			tNear = t1;
		if(t2 < tFar)
			tFar = t2;
		if(tNear > tFar)
			return;// -1;
		if(tFar < 0.0)
			return;// -1;
	}

	if(tNear >= -100000.0)
		t = tNear;
	else
		return;// -1;

	if ( (t > 0.0) && (t < isect.t) )
	{
		vec3 IntersectionPoint = ro + rd * t;
		isect.t = t;
		isect.hit = 1;

		// calculate normal
		isect.p = IntersectionPoint;
	
		isect.t = t;
		isect.p = IntersectionPoint;     // it point
		isect.hit = 1;
		isect.col = c.col;
	
		vec3 normal = vec3(0.0,0.0,0.0);
	
		if(IntersectionPoint.x >= vertex2.x - 0.005 && IntersectionPoint.x <= vertex2.x + 0.005)
			normal = vec3(1.0, 0.0, 0.0);
		else if(IntersectionPoint.x >= vertex1.x - 0.005 && IntersectionPoint.x <= vertex1.x + 0.005)
			normal = vec3(-1.0, 0.0, 0.0);
		else if(IntersectionPoint.y >= vertex2.y - 0.005 && IntersectionPoint.y <= vertex2.y + 0.005)
			normal = vec3(0.0, 1.0, 0.0);
		else if(IntersectionPoint.y >= vertex1.y - 0.005 && IntersectionPoint.y <= vertex1.y + 0.005)
			normal = vec3(0.0, -1.0, 0.0);
		else if(IntersectionPoint.z >= vertex2.z - 0.005 && IntersectionPoint.z <= vertex2.z + 0.005)
			normal = vec3(0.0, 0.0, 1.0);
		else if(IntersectionPoint.z >= vertex1.z - 0.005 && IntersectionPoint.z <= vertex1.z + 0.005)
			normal = vec3(0.0, 0.0, -1.0);

		isect.n = normal;
		
		isect.col = c.col;
	}
}

Sphere sphere[4];
Cube cube[1];
Plane plane;

void Intersect(Ray r, inout Intersection i)
{
	for (int c = 0; c < 3; c++)
	{
		//shpere_intersect(sphere[c], r, i);
	}

	sphere_intersect(sphere[0], r, i);
	sphere_intersect(sphere[1], r, i);
	sphere_intersect(sphere[2], r, i);
	sphere_intersect(sphere[3], r, i);
	
	cube_intersect(cube[0], r, i);
	
	plane_intersect(plane, r, i);
}

int seed = 0;
float random()
{
	seed = int(mod(float(seed)*1364.0+626.0, 509.0));
	return float(seed)/509.0;
}
vec3 computeLightShadow(in Intersection isect)
{
	int i, j;
	int ntheta = 16;
	int nphi   = 16;
	float eps  = 0.001;

	// Slightly move ray org towards ray dir to avoid numerical probrem.
	vec3 p = vec3(isect.p.x + eps * isect.n.x,
				isect.p.y + eps * isect.n.y,
				isect.p.z + eps * isect.n.z);

	vec3 lightPoint = vec3(5,5,5);
	Ray ray;
	ray.org = p;
	ray.dir = normalize(lightPoint - p);

	Intersection lisect;
	lisect.hit = 0;
	lisect.t = 1.0e+30;
	lisect.n = lisect.p = lisect.col = vec3(0, 0, 0);
	Intersect(ray, lisect);
	if (lisect.hit != 0)
		return vec3(0.0,0.0,0.0);
	else
	{
		float shade = max(0.0, dot(isect.n, ray.dir));
		shade = pow(shade,2.0) + shade * 0.5;
		return vec3(shade,shade,shade);
	}
	
}

void main( void ) 
{
	float time = 1.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position -= vec2( 0.5,0.5 );
	position.x *= 2.0;
	//asdfasdf
	float ss = sin(time*0.3);
	float cc = cos(time*0.3);
	//vec3 org = vec3(ss*4.0,0,cc*4.0);
	vec3 org = vec3(ss*6.0,0.0,cc*6.0);
	vec3 dir = normalize(vec3(position.x*cc-ss,position.y, -position.x*ss-cc));

	sphere[0].c   = vec3(-2.0, 0.0+sin(time)*.5+0.5, -1.0);
	//sphere[0].c   = vec3( 0.0, 0.0, -2.0);
	sphere[0].r   = 0.5;
	sphere[0].col = vec3(1,0.3,0.3);
	sphere[1].c   = vec3(sin(time+3.14)*1.5-0.5, 0.0, -1.0);
	//sphere[1].c   = vec3(-0.5, 0.0, -1.0);
	sphere[1].r   = 0.5;
	sphere[1].col = vec3(0.3,1,0.3);
	sphere[2].c   = vec3(1.0, sin(time+3.14)*.5*0.5, 0.0);
	//sphere[2].c   = vec3(1.0, 0.5, 0.0);
	sphere[2].r   = 0.5;
	sphere[2].col = vec3(0.43,0.3,1);
	sphere[3].c   = vec3(-2.0, sin(time+3.14)*.5+0.5, -1.50);
	//sphere[3].c   = vec3(0.0, 0.5, 1.0);
	sphere[3].r   = 0.5;
	sphere[3].col = vec3(0.8,0.3,1);
	
	//cube[0].c = vec3(2.0, 0.5, 2.0);
	//cube[0].h_side = vec3(0.5);
	//cube[0].col = vec3(1.0, 1.0, 0.0);
	
	plane.p = vec3(0,-0.5, 0);
	plane.n = vec3(0, 1.0, 0);
	plane.col = vec3(1,1, 1);
	
	Ray r;
	r.org = org;
	r.dir = normalize(dir);
	vec4 col = vec4(0,0,0,1);
	float eps  = 0.0001;
	vec3 bcol = vec3(1,1,1);
	for (int j = 0; j < raytraceDepth; j++)
	{
		Intersection i;
		i.hit = 0;
		i.t = 1.0e+30;
		i.n = i.p = i.col = vec3(0, 0, 0);
			
		Intersect(r, i);
		if (i.hit != 0)
		{
			col.rgb += bcol * i.col * computeLightShadow(i);
			bcol *= i.col;
		}
		else
		{
			break;
		}
				
		r.org = vec3(i.p.x + eps * i.n.x,
					 i.p.y + eps * i.n.y,
					 i.p.z + eps * i.n.z);
		r.dir = reflect(r.dir, vec3(i.n.x, i.n.y, i.n.z));
	}
	gl_FragColor = col;
	
#if 0	
	    Ray r;
	    r.org = org;
	    r.dir = normalize(dir);
	    vec4 col = vec4(0,0,0,1);
	    
	    Intersection i;
	    i.hit = 0;
	    i.t = 1.0e+30;
//	    i.t = 999999.0;
		i.n = i.p = i.col = vec3(0, 0, 0);
	
	
		    
	    Intersect(r, i);
	
//	shpere_intersect(sphere[0], r, i);
//	shpere_intersect(sphere[1], r, i);
//	shpere_intersect(sphere[2], r, i);
	
//	plane_intersect(plane, r, i);
	    
	if (i.hit != 0)
	{
		vec3 lightDir = normalize(vec3(1,1,1));
		
		float eps  = 0.0001;
		Ray rsh;
		rsh.org = i.p + i.n * eps;// 法線方向にすこしずらす\n		rsh.dir = reflect(r.dir, i.n);// 反射ベクトル
		Intersection ish;
		ish.hit = 0;
		ish.t = 1.0e+30;
		ish.n = ish.p = ish.col = vec3(0, 0, 0);
		Intersect(rsh, ish);
			
		col.rgb = max(0.0, dot(i.n, lightDir)) * i.col;
		col.rgb += ish.col;// 反射したオブジェクトの色を追加\n/*
#if 0
	   // display normal
	   col.rgb = i.n;
#else
	   // display position
	   col.rgb = i.p;
	   col.b = 0.5;
#endif  
*/
	}
	gl_FragColor = col;
#endif	
	
	
//	gl_FragColor = vec4(normalize(dir),1);
/*	
	vec4 col = vec4( 0,0,0,1 );
	
	vec2 m = mouse / resolution.xy;
	
	Rect r;
	r.left = mouse.x - 0.1;
	r.top = mouse.y - 0.1;
	r.right = mouse.x + 0.1;
	r.bottom = mouse.y + 0.1;
	r.c = vec4( 1,0,0,1 );
	
	if( isInRect( r,position ) ){
		col = r.c;
	}
	gl_FragColor = col;
*/
//	gl_FragColor = vec4( position.x,1.0,position.y, 1.0 );
/*
	float color = 0.0;
	color += sin( position.x * cos( time / 10.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
*/
}