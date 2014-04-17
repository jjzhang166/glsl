#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

#define EPSILON 0.0001
#define RAY_STEPS 64
#define MAX_DISTANCE 6.0
#define int4 vec4
#define dis x
#define obj y
#define mat z
#define ref w
#define BUILD_COLOR(c) vec4(min(c, 1.0), 1.0)
#define SPHERE(p,r) length(p) - r
#define BOX(p,b) length(max(abs(p) - b, 0.0))
#define PLANE(p,z) p.y + z
#define SPHERE_DOMAIN(p,r,c) SPHERE(mod(p, c) - 0.5 * c, r)
#define BOX_DOMAIN(p,b,c) BOX(mod(p, c) - 0.5 * c, b)
#define renderable(a,b) ((a == 0.0) || (a == b))

const float FOG_FACTOR = 0.1;
const vec3 FOG_COLOR = vec3(0.5, 0.6, 0.7);


const int4 DEFAULT_INT4 = int4(MAX_DISTANCE, 0.0, 0.0, 0.0);
const vec3 BACKGROUND_COLOR = vec3(0.01);
const vec3 AMBIENT_COLOR = vec3(0.01);
const vec3 NORMAL_BIAS = vec3(0.001, 0.0, 0.0);
const float SHADOW_FACTOR = 6.0;

int4 map(in vec3 p, in float obj)
{
	int4 d0 = DEFAULT_INT4;
	int4 d1, d2, d3, d4;

	if (renderable(obj, 1.0))
	{
		d1 = int4(SPHERE(p - vec3(cos(time) * 1.3, sin(time) * 1.3, 0.0), 0.5), 1.0, 1.0, 0.5);
		if (d1.dis < d0.dis) d0 = d1;
	}
	if (renderable(obj, 4.0))
	{
		d1 = int4(SPHERE(p - vec3(0.0, cos(time) * 1.5, sin(time) * 1.5), 0.5), 1.0, 1.0, 0.5);
		if (d1.dis < d0.dis) d0 = d1;
	}
	if (renderable(obj, 2.0))
	{
		d1 = int4(SPHERE(p - vec3(0.0, 0.0, 0.0), 0.5), 2.0, 2.0, 0.0);
		if (d1.dis < d0.dis) d0 = d1;
	}
	if (renderable(obj, 3.0))
	{
		d1 = int4(PLANE((p - vec3(1.0, 1.0, 1.0)), 3.0), 3.0, 3.0, 1.0);
		if (d1.dis < d0.dis) d0 = d1;
	}
	    
	return d0;	
}

int4 intersect(in vec3 ro, in vec3 rd)
{
	float t = 0.5;

	for (int i = 0; i < RAY_STEPS; ++i)
	{
		int4 h = map(ro + t * rd, 0.0);
		if (h.dis < EPSILON)
		{
			h.dis = t;
			return h;
		}

		t += h.x;
		if (t > MAX_DISTANCE)
			break;
	}
	return DEFAULT_INT4;
}

float shadow(in vec3 ro, in vec3 rd)
{
	float r = 1.00;
	float t = 0.01;
	
	for (int i = 0; i < RAY_STEPS; ++i)
	{
		float h = map(ro + t * rd, 0.0).x;
		if (h < EPSILON)
			return 0.0;
		r = min(r, SHADOW_FACTOR * h / t);
		t+= h;
	}
	
	return  r;
}

float ao(in vec3 ro, in vec3 rd, in vec3 pos, in vec3 nor)
{
	float ao;
	float totao = 0.0;
	float sca   = 1.0;
	
	for (int aoi = 0; aoi < 5; aoi++)
	{
		float hr    = 0.01 + 0.02 * float(aoi * aoi);
		vec3  aopos = nor * hr + pos;
		float dd    = intersect(ro, rd).dis;
		ao     = -(dd - hr);
		totao += ao * sca;
		sca   *= 0.75;
	}
	
	return 1.0 - clamp(totao, 0.0, 1.0);
}

vec3 normal(in vec3 p, in int4 obj)
{
	return normalize(vec3(
		map(p + NORMAL_BIAS.xyy, obj.obj).x - map(p - NORMAL_BIAS.xyy, obj.obj).x,
		map(p + NORMAL_BIAS.yxy, obj.obj).x - map(p - NORMAL_BIAS.yxy, obj.obj).x,
		map(p + NORMAL_BIAS.yyx, obj.obj).x - map(p - NORMAL_BIAS.yyx, obj.obj).x
	));
}

vec3 raydir(in vec3 ro, in float rot, in float z, in vec2 q)
{
	vec2 p = -1.0 + 2.0 * q;
	p.x *= resolution.x / resolution.y;
	vec3 ww = normalize(-ro);
	vec3 uu = normalize(cross(vec3(rot, 5.0, 0.0), ww));
	vec3 vv = normalize(cross(ww, uu));
	
	return normalize(p.x * uu + p.y * vv + z * ww);
}

vec3 prelight(in vec3 ro, in vec3 rd, in int4 obj, in vec3 col, out vec3 pos, out vec3 nor)
{
	pos = ro + obj.dis * rd;
	nor = normal(pos, obj);

	float  amb = 0.5 + 0.5 * nor.y;
	return col + amb * AMBIENT_COLOR;
}

vec3 light(in vec3 lig, in vec3 lcol, in vec3 col, in vec3 pos, in vec3 nor)
{
	if (dot(nor, lig) < 0.0)
		return col;	// Light source on the wrong side.
	
	lig = normalize(lig);
	float sha = shadow(pos, lig);
	col += max(0.0, dot(nor, lig)) * lcol * sha;
	
	return col;
}

vec3 postlight(in vec3 ro, in vec3 rd, in vec3 pos, in vec3 nor, in vec3 dif, in vec3 col, in vec2 q)
{
	col = col * dif * ao(ro, rd, pos, nor);
	col = 0.3 * col + 0.5 * sqrt(col);
	col *= 0.25 + 0.75 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.15);
	
	return col;
}

vec3 specular(in vec3 rd, in vec3 pos, in vec3 nor, in vec3 lig, in vec3 lcol, in float shi, in vec3 col)
{
	if (dot(nor, lig) < 0.0)
		return col;	// Light source on the wrong side.
	
	col += lcol * pow(max(0.0, dot(nor, normalize(rd - pos + lig))), shi);
	
	return col;
}

vec3 fog(in vec3 rd, in vec3 col, in float dis)
{
	rd.y += 0.2;
	return mix(col, FOG_COLOR, 0.2 * (1.0 - exp(-dis * rd.y * FOG_FACTOR)) / rd.y);
}

vec3 render(in vec3 ro, in vec3 rd, in vec2 q, out vec3 pos, out vec3 nor, out int4 obj)
{
	vec3 col = BACKGROUND_COLOR;
	
	vec3 lig = vec3(-0.5, 1.0, 4.0);
	vec3 lcol = vec3(1.0, 1.0, 0.5);
	vec3 dif = vec3(0.2, 0.2, 0.7);
	
	obj = intersect(ro, rd);
	if (obj.obj > 0.5)
	{
		col = prelight (ro, rd, obj, col, pos, nor);
		col = light    (lig, lcol, col, pos, nor);
		col = postlight(ro, rd, pos, nor, dif, col, q);
		col = specular (rd, pos, nor, lig, lcol, 10.0, col);
	}
	
	return col;
}

void main(void)
{
	vec2 q = gl_FragCoord.xy / (resolution.xy + 1.0);
	vec3 ro = vec3(0.0, 0.0, 4.0);
	vec3 rd = raydir(ro, 0.0, 1.5, q);
	
	ro.x = cos(time * 0.5);
	ro.z = 4.0 + sin(time);

	vec3 pos, nor;
	int4 obj, ref;
	vec3 col = render(ro, rd, q, pos, nor, obj);

	if (obj.ref > 0.0)
	{
		vec3 col2 = render(pos, nor, q, pos, nor, ref);
		col+= col2 * obj.ref;
	}
	col = fog(rd, col, obj.dis);
	
	gl_FragColor = BUILD_COLOR(col);	
}