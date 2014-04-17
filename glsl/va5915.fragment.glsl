//                                                    naïve performance test
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
varying vec2 surfacePosition;

//
// Description : Array and textureless GLSL 2D/3D/4D 
//               noise functions with wrapping
//      Author : People
//  Maintainer : Anyone
//     Lastmod : 20120109 (Trisomie21)
//     License : No Copyright No rights reserved.
//               Freely distributed
//
float snoise(vec3 uv, float res)
{
	const vec3 s = vec3(1e0, 1e2, 1e4);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv);
	f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-3)*1e5);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-1.;
}

const float Tau = 6.2832;


void fireball()
{
	vec2 p = surfacePosition;
	
	float color = 3.0 - (3.*length(2.*p));
	
	vec3 coord = vec3(atan(p.x,p.y)/Tau+.5, length(p)*.4, .5);
	
	for(int i = 1; i <= 7; i++)
	{
		float power = pow(2.0, float(i));
		color += (1.5 / power) * snoise(coord + vec3(0.,-time*.05, time*.01), power*16.);
	}

	gl_FragColor = vec4( color, pow(max(color,0.),2.)*0.4, pow(max(color,0.),3.)*0.15 , 1.0);
}


mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*10.0;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float length2( vec2 p )
{
    float ax = abs(p.x);
    float ay = abs(p.y);
    return pow( pow(ax,4.0) + pow(ay,4.0), 1.0/4.0 );
}

//--- eye -----------------------
void eye()
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
    float r = length( p );
    float a = atan( p.y, p.x );
    float dd = 0.2*sin(0.7*time);
    float ss = 1.0 + clamp(1.0-r,0.0,1.0)*dd;
    r *= ss;
    vec3 col = vec3( 0.0, 0.3, 0.4 );
    float f = fbm( 5.0*p );
    col = mix( col, vec3(0.2,0.5,0.4), f );
    col = mix( col, vec3(0.9,0.6,0.2), 1.0-smoothstep(0.2,0.6,r) );
    a += 0.05*fbm( 20.0*p );
    f = smoothstep( 0.3, 1.0, fbm( vec2(20.0*a,6.0*r) ) );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    f = smoothstep( 0.4, 0.9, fbm( vec2(15.0*a,10.0*r) ) );
    col *= 1.0-0.5*f;
    col *= 1.0-0.25*smoothstep( 0.6,0.8,r );
    f = 1.0-smoothstep( 0.0, 0.6, length2( mat2(0.6,0.8,-0.8,0.6)*(p-vec2(0.3,0.5) )*vec2(1.0,2.0)) );
    col += vec3(1.0,0.9,0.9)*f*0.985;
    col *= vec3(0.8+0.2*cos(r*a));
    f = 1.0-smoothstep( 0.2, 0.25, r );
    col = mix( col, vec3(0.0), f );
    f = smoothstep( 0.79, 0.82, r );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    gl_FragColor = vec4(col,1.0);	
}

//---   raymarching -----------------------
// consts
const float PI = 3.1415926;
const vec3 UP = vec3 (0,0,1);
const vec3 Z3 = vec3(0,0,0);
const vec3 U3 = vec3(1,1,1);

const float INFINITY = 1.0/0.0;

// camera
const vec3 at = UP;///2.0;
const float fov = PI / 2.0;
float tanfov = tan(fov/1.8);

// structs
struct Camera
{
	vec3 Position;
	vec3 Side;
	vec3 Up;
	vec3 View;
	vec2 Scale;
};

struct Ray
{
	vec3 Position;
	vec3 Direction;
};

struct Sphere
{
	vec3 Center;
	float Radius;
};

struct Plane
{
	vec3 Point;
	vec3 Normal;
};

struct PointLight
{
	vec3 Position;
	vec3 DiffuseColor;
	vec3 SpecularColor;
};

struct Material
{
	vec3 DiffuseColor;
	float DiffuseReflectivity;
	vec3 SpecularColor;
	float SpecularReflectivity;
	float Shininess;
};

struct Ball
{
	Sphere Sphere;
	Material Material;
	vec3 Velocity;
};


struct Bounce
{
	Ray Normal;
	Material Material;
};


const Material _matFloor = Material (U3, .8, U3, .4, 130.0);
const Plane _floor = Plane (vec3(0,0,0), vec3(0,0,1));

const int _cLights = 3;
PointLight _rgLights[_cLights];

const int _cBalls = 7;
Ball _rgBalls[_cBalls];


vec2 Circle (const float time)
{
	return vec2 (cos(time), sin(time));
}


float IntersectSphere (const Ray ray, const Sphere sphere, inout Ray normal)
{
	vec3 L = sphere.Center - ray.Position;
	float Tca = max (0.0, dot (L, ray.Direction));
	if (Tca < 0.0)
		return INFINITY;

	float d2 = dot (L, L) - Tca * Tca;
	float p2 = sphere.Radius * sphere.Radius - d2;
	if (p2 < 0.0)
		return INFINITY;

	float t = Tca - sqrt (p2);
	vec3 intersect = ray.Position + t * ray.Direction;
	normal = Ray (intersect, (intersect - sphere.Center) / sphere.Radius);
	return t;
}

float IntersectPlane (const Ray ray, const Plane plane, inout Ray normal)
{
	float t = dot (plane.Point - ray.Position, plane.Normal) / dot (ray.Direction, plane.Normal);
	normal = Ray (ray.Position + t * ray.Direction, plane.Normal);
	return t;
}

vec3 Phong (const PointLight light, const Material material, const Ray normal, vec3 eye)
{
	vec3 viewDir = normalize (normal.Position - eye);
	vec3 lightVec = light.Position - normal.Position;
	float lightDistance2 = dot (lightVec, lightVec);
	vec3 lightDir = lightVec / sqrt (lightDistance2);
	float diffuse = dot(normal.Direction, lightDir);

	vec3 R = lightDir - 2.0 * diffuse * normal.Direction;
	float specular = pow(max(0.0, dot(R, viewDir)), material.Shininess);

	vec3 color =
		max (0.0, diffuse) * light.DiffuseColor * material.DiffuseReflectivity * material.DiffuseColor +
		max (0.0, specular) * light.SpecularColor * material.SpecularReflectivity * material.SpecularColor;
	return color * 100.0 / lightDistance2;
}

bool Scene (const Ray ray, out Bounce bounce)
{
	float tMatch = INFINITY;
	Ray normalMatch;
	for (int i = 0; i < _cBalls; ++i)
	{
		Ray normal;
		float t = max(0.0, IntersectSphere (ray, _rgBalls[i].Sphere, normal));
		if (t > 0.0 && tMatch > t)
		{
			tMatch = t;
			bounce = Bounce (normal, _rgBalls[i].Material);
		}
	}

	Ray normalPlane;
	float t2 = IntersectPlane (ray, _floor, normalPlane);
	if (t2 > 0.0 && t2 < tMatch)
	{
		vec3 pt = normalPlane.Position;
		if (length(pt) < 10.0 && (fract(pt.x) < 0.9 == fract(pt.y) < 0.9))
		{
			tMatch = t2;
			bounce = Bounce (normalPlane, _matFloor);
		}
	}

	return tMatch < 1000.0 && tMatch > 0.0;
}

bool LightScene (inout Ray ray, inout vec3 color, inout float reflectivity)
{
	Bounce bounce;
	if (!Scene (ray, bounce))
		return false;

	vec3 bouncePos = bounce.Normal.Position + bounce.Normal.Direction * .0001;

	Bounce bounceShadow;

	for (int iLight = 0; iLight < _cLights; ++iLight)
	{
		if (!Scene (Ray (bouncePos, normalize (_rgLights[iLight].Position - bouncePos)), bounceShadow))
			color += reflectivity * Phong (_rgLights[iLight], bounce.Material, bounce.Normal, ray.Position);
	}

	reflectivity *= bounce.Material.SpecularReflectivity;
	ray = Ray (bouncePos, reflect (ray.Direction, bounce.Normal.Direction));
	return true;	
}

const Sphere s = Sphere (Z3, .5);

void raymarching ()
{
	float time2 = time / 2.0 + 100.0;

	vec3 eye = vec3(Circle(time / 10.0 + 10.0 * mouse.x) * (7.1 - 4.5 * mouse.y), 4.5 * mouse.y);
	vec3 look = normalize (at - eye);

	vec3 u = cross (look, UP);
	vec3 v = cross (u, look);

	vec3 dx = tanfov * u;
	vec3 dy = tanfov * v;

	vec2 position = (gl_FragCoord.xy - resolution/2.0) / min(resolution.x, resolution.y);
	Ray ray = Ray (eye, normalize (look + dx * position.x + dy * position.y));

	_rgBalls[0] = Ball(s, Material (vec3(1,0,0), .5, U3, .9, 100.0), vec3(1.17, 1.9, 3.03));
	_rgBalls[1] = Ball(s, Material (vec3(0,1,0), .5, U3, .9, 100.0), vec3(1.23, 1.8, 1.79));
	_rgBalls[2] = Ball(s, Material (vec3(0,0,1), .5, U3, .9, 100.0), vec3(1.35, 1.7, 2.73));
	_rgBalls[3] = Ball(s, Material (vec3(0,1,1), .5, U3, .9, 100.0), vec3(1.41, 1.6, 2.53));
	_rgBalls[4] = Ball(s, Material (vec3(1,0,1), .5, U3, .9, 100.0), vec3(1.50, 1.5, 2.23));
	//_rgBalls[5] = Ball(s, Material (vec3(1,1,0), .5, U3, .9, 100.0), vec3(1.69, 1.4, 1.93));
	_rgBalls[6] = Ball(s, Material (vec3(1,1,1), .9, U3, .05,  10.0), vec3(1.39, 1.19, 1.93));
	_rgBalls[5] = Ball(s, Material (vec3(0,0,0), .99, U3, .07,  10.0), vec3(1.79, 1.01, 2.33));

	for (int i = 0; i < _cBalls; ++i)
	{
		float q = fract(time2 * _rgBalls[i].Velocity.z / 3.0) - 0.5;

		_rgBalls[i].Sphere.Center = vec3 (
			abs(mod(time2 * _rgBalls[i].Velocity.xy, 8.0) - 4.0) - 2.0,
			_rgBalls[i].Sphere.Radius + 8.0 * (0.25-q*q));
	}


	_rgLights [0] = PointLight (4.0*vec3(1,0.,2), vec3(.5,1,.5) * .6, vec3(.5,1,.5));
	_rgLights [1] = PointLight (4.0*vec3(-1,-0.86,2), vec3(1,.5,.5) * .6, vec3(1,.5,.5));
	_rgLights [2] = PointLight (4.0*vec3(-1,0.86,2), vec3(.5,.5,1) * .6, vec3(.5,.5,1));


	vec3 color = vec3(0,0,0);
	float reflectivity = 1.0;

	LightScene (ray, color, reflectivity) &&
		LightScene (ray, color, reflectivity) &&
		LightScene (ray, color, reflectivity) &&
		LightScene (ray, color, reflectivity);
	gl_FragColor = vec4 (color, 1.0);
}


void main(void) 
{	
	bvec2 q = lessThan( gl_FragCoord.xy / resolution.xy , vec2(0.5));

	if ( q.y )
	{
		raymarching ();
	}
	if ( q.x && !q.y )
	{
		eye();
	}
	
	if ( !q.x && !q.y )
	{
		fireball();	
	}
	
}