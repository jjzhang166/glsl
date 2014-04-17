#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie 21
// A try at a fake single pass delayed DoF

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D frame;

vec2 dxy = 1./resolution;


// Scene from : http://glsl.heroku.com/e#969

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

const int _cBalls = 3;
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

float Scene (const Ray ray, out Bounce bounce)
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

	return tMatch;
}

float LightScene (inout Ray ray, inout vec3 color, inout float reflectivity)
{
	Bounce bounce;
	float depth = Scene(ray, bounce);
	bool tMatch =  depth< 1000.0 && depth > 0.0;
	if (!tMatch)
		return 1.;

	vec3 bouncePos = bounce.Normal.Position + bounce.Normal.Direction * .0001;

	Bounce bounceShadow;

	for (int iLight = 0; iLight < _cLights; ++iLight)
	{
	float depth = Scene (Ray (bouncePos, normalize (_rgLights[iLight].Position - bouncePos)), bounceShadow);
	tMatch =  depth< 1000.0 && depth > 0.0;
		
		if (!tMatch)
			color += reflectivity * Phong (_rgLights[iLight], bounce.Material, bounce.Normal, ray.Position);
	}

	reflectivity *= bounce.Material.SpecularReflectivity;
	ray = Ray (bouncePos, reflect (ray.Direction, bounce.Normal.Direction));
	return depth/5.;	
}

const Sphere s = Sphere (Z3, .5);

vec4 func( vec2 p )
{
	float time2 = time / 2.0 + 100.0;

	vec3 eye = vec3(Circle(10.0 * mouse.x) * (7.1 - 4.5 * mouse.y), 4.5 * mouse.y);
	vec3 look = normalize (at - eye);

	vec3 u = cross (look, UP);
	vec3 v = cross (u, look);

	vec3 dx = tanfov * u;
	vec3 dy = tanfov * v;

	vec2 position = p*.5;//(gl_FragCoord.xy - resolution/2.0) / min(resolution.x, resolution.y);
	position.x *= resolution.x/ resolution.y;
	Ray ray = Ray (eye, normalize (look + dx * position.x + dy * position.y));

	_rgBalls[0] = Ball(s, Material (vec3(1,0,0), .5, U3, .9, 100.0), vec3(1.17, 1.9, 3.03));
	_rgBalls[1] = Ball(s, Material (vec3(0,1,0), .5, U3, .9, 100.0), vec3(1.23, 1.8, 1.79));
	_rgBalls[2] = Ball(s, Material (vec3(0,0,1), .5, U3, .9, 100.0), vec3(1.35, 1.7, 2.73));

	for (int i = 0; i < _cBalls; ++i)
	{
		float q = fract(time2 * _rgBalls[i].Velocity.z*.1 / 3.0) - 0.5;

		_rgBalls[i].Sphere.Center = vec3 (
			abs(mod( _rgBalls[i].Velocity.xy*200.5, 12.0) - 6.0) - 3.0,
			_rgBalls[i].Sphere.Radius + 8.0 * (0.25-q*q));
	}

	_rgLights [0] = PointLight (4.0*vec3(1,0.,2), vec3(.5,1,.5) * .6, vec3(.5,1,.5));
	_rgLights [1] = PointLight (4.0*vec3(-1,-0.86,2), vec3(1,.5,.5) * .6, vec3(1,.5,.5));
	_rgLights [2] = PointLight (4.0*vec3(-1,0.86,2), vec3(.5,.5,1) * .6, vec3(.5,.5,1));

	vec3 color = vec3(0,0,0);
	float reflectivity = 1.0;

	float depth = LightScene (ray, color, reflectivity);// &&
	LightScene (ray, color, reflectivity);

	return vec4 (color, depth);
}
#if 0 // Bilinear
vec4 sample(vec2 offset, vec2 uv, vec2 res) {
	vec2 xy = (uv * res)+.5;
	vec2 f = fract(xy);
	xy = floor(xy)/resolution + offset + dxy*.1;
	vec4 color = mix(mix(texture2D(frame, xy+dxy*vec2(0.,0.)), texture2D(frame, xy+dxy*vec2(1.,0.)), f.x),
			 mix(texture2D(frame, xy+dxy*vec2(0.,1.)), texture2D(frame, xy+dxy*vec2(1.,1.)), f.x), f.y);
	return color;
}
#else // Cubic
vec4 sample(vec2 offset, vec2 uv, vec2 res) {
	
	vec2 ddxy = 1.0/resolution;
	vec2 xy = (uv * res)+.5;
	vec2 f = fract(xy);
	xy = floor(xy)/resolution + offset + dxy*.1;
	
	vec2 st0 = ((2.0 - f) * f - 1.0) * f;
	vec2 st1 = (3.0 * f - 5.0) * f * f + 2.0;
	vec2 st2 = ((4.0 - 3.0 * f) * f + 1.0) * f;
	vec2 st3 = (f - 1.0) * f * f;
	
	vec4 row0 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, -1.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, -1.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, -1.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, -1.0));
	vec4 row1 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 0.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 0.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 0.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 0.0));
	vec4 row2 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 1.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 1.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 1.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 1.0));
	vec4 row3 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 2.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 2.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 2.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 2.0));
	
	return 0.25 * ((st0.t * row0) + (st1.t * row1) + (st2.t * row2) + (st3.t * row3));
}
#endif

vec4 sample(vec2 uv, float level) {
	float mip = floor(level);
	float f = fract(level);	
	vec4 c = sample(vec2(1.-pow(.5, mip), 1.-pow(.5, mip+1.)), uv, resolution*pow(.5, mip+1.))*(1.-f);	
	mip += 1.;
	c += sample(vec2(1.-pow(.5, mip), 1.-pow(.5, mip+1.)), uv, resolution*pow(.5, mip+1.))*f;
	return c;
}

void main( void )
{
	vec2 margin;

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec2 uv = mod(p*2., 1.);
	
	// Top left : Source frame
	if(p.x < .5 && p.y > .5) { 
		gl_FragColor = func(uv*2.-1.);
		return;
	}
	
	// Top right : mipmap
	if(p.x > .5 && p.y > .5) { 
		if(p.y < .752) {
			gl_FragColor = vec4(.3);
			return;
		}
		uv -= dxy*2.5;
		vec4 color = vec4(0.);
		for(float j=0.; j<5.; j++) for(float i=0.; i<5.; i++) 
			color  += texture2D(frame, uv+dxy*vec2(i,j));
		gl_FragColor = color/25.;
		return;
	}
	
	// Bottom right : debug out , swipe color & Z blur	
	margin = abs(p-.25-vec2(.5,0.)) - .25 + dxy*0.;
	if(margin.x < 0. && margin.y < 0.) {
		vec4 c = gl_FragColor = vec4(sample(uv, 4.5));
		if(p.y > (sin(time)+1.)*.25) gl_FragColor = c;
		else gl_FragColor = vec4(c.w);
		return;
	}
	
	// Botom left : Final composite
	margin = abs(p-.25) - .25 + dxy*4.;
	if(margin.x < 0. && margin.y < 0.) { 
		float level = sample(uv, 1.0).w;//min(sample(uv, 3.5).w, texture2D(frame, uv*.5+vec2(0.,.5)).w);
		level *= 2.5;
		vec4 color = sample(uv, level);
		gl_FragColor = color;	
		return;
	} else gl_FragColor = vec4(.6,.2,0.6,0.);
	
}