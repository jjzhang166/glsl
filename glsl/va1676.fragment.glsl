#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// @blurspline
// playing with porting http://code.google.com/p/glsl-raytracer/source/browse/trunk/GLSL+Raytracer/rt.frag
// fixed some resolution sutff.
// if you're in ANGEL, you may get error X3000
// about:config > webgl.prefer-native-gl = true, Chrome: chrome.exe --use-gl=desktop

#define OBJ_NB			3
#define OBJ_SPHERE		1
#define OBJ_PLAN		2
#define F_NULL			0.001


struct		s_obj
{
	vec4	color;
	vec3	pos;
	vec3	rot;
	float	ray;
	float	reflect;
	float	refract;
	int		type;
};

struct		s_work
{
	s_obj	obj;
	vec3	normal;
	vec3	point;
	float	dis;
	bool	flag;
};

s_work		work;
s_obj		obj[OBJ_NB];

vec3		rotate_x(vec3 vec, float angle)
{
	mat3	mat;
	float	cosa, sina;
	
	angle = radians(angle);
	cosa = cos(angle);
	sina = sin(angle);
	mat = mat3(vec3(1, 0, 0), vec3(0, cosa, -sina), vec3(0, sina, cosa));
	vec = vec * mat;
	return vec;
}

vec3		rotate_y(vec3 vec, float angle)
{
	mat3	mat;
	float	cosa, sina;
	
	angle = radians(angle);
	cosa = cos(angle);
	sina = sin(angle);
	mat = mat3(vec3(cosa, 0, -sina), vec3(0, 1, 0), vec3(sina, 0, cosa));
	vec = vec * mat;
	return vec;
}

vec3		rotate_z(vec3 vec, float angle)
{
	mat3	mat;
	float	cosa, sina;
	
	angle = radians(angle);
	cosa = cos(angle);
	sina = sin(angle);
	mat = mat3(vec3(cosa, -sina, 0), vec3(sina, cosa, 0), vec3(0, 0, 1));
	vec = vec * mat;
	return vec;
}

vec3		vec_rotate_inv(vec3 vec, vec3 rot)
{
	if (rot.z < -F_NULL || rot.z > F_NULL)
		vec = rotate_z(vec, -rot.z);
	if (rot.y < -F_NULL || rot.y > F_NULL)
		vec = rotate_y(vec, -rot.y);
	if (rot.x < -F_NULL || rot.x > F_NULL)
		vec = rotate_x(vec, -rot.x);
	return vec;
}

vec3		vec_rotate(vec3 vec, vec3 rot)
{
	if (rot.x < -F_NULL || rot.x > F_NULL)
		vec = rotate_x(vec, rot.x);
	if (rot.y < -F_NULL || rot.y > F_NULL)
		vec = rotate_y(vec, rot.y);
	if (rot.z < -F_NULL || rot.z > F_NULL)
		vec = rotate_z(vec, rot.z);
	return (vec);
}

void		dis_save(float dis, vec3 ray, vec3 eyes, s_obj obj)
{
	if (dis > F_NULL && dis < work.dis)
	{
		work.point = vec3(eyes.x + dis * ray.x, eyes.y + dis * ray.y, eyes.z + dis * ray.z);
		if (obj.type == OBJ_PLAN)
			work.normal = vec3(0, 0, 1);
		else if (obj.type == OBJ_SPHERE)
			work.normal = normalize(vec3(work.point.x, work.point.y, work.point.z));	
		work.obj = obj;
		work.dis = dis;
		work.flag = true;

		work.point = vec_rotate(work.point, obj.rot);
		work.point += obj.pos;
		work.normal = vec_rotate(work.normal, obj.rot);
	}
}

void		hit_sphere(vec3 ray, vec3 eyes, s_obj obj)
{
	float	dis, delta, a, b, c, sol1, sol2;

	eyes -= obj.pos;
	eyes = vec_rotate_inv(eyes, obj.rot);
	ray = vec_rotate_inv(ray, obj.rot);

	a = ray.x * ray.x + ray.y * ray.y + ray.z * ray.z;
	b = 2.0 * (ray.x * eyes.x + ray.y * eyes.y + ray.z * eyes.z);
	c = eyes.x * eyes.x + eyes.y * eyes.y + eyes.z * eyes.z - obj.ray * obj.ray;
	delta = b * b - 4.0 * a * c;
	if (delta > F_NULL)
	{
		dis = (2.0 * a);
		sol1 = (-b + sqrt(delta)) / dis;
		sol2 = (-b - sqrt(delta)) / dis;
		dis = sol1;
		if (sol2 > F_NULL && sol2 < sol1)
			dis = sol2;
		dis_save(dis, ray, eyes, obj);
	}
}

void		hit_plan(vec3 ray, vec3 eyes, s_obj obj)
{
	float	dis;

	eyes -= obj.pos;
	eyes = vec_rotate_inv(eyes, obj.rot);
	ray = vec_rotate_inv(ray, obj.rot);
	if (eyes.z < -F_NULL || eyes.z > F_NULL)
	{
		dis = -eyes.z / ray.z;
		dis_save(dis, ray, eyes, obj);
	}
}

void		inter_obj(vec3 ray, vec3 eyes)
{
	work.dis = 10000.0;
	work.flag = false;
	for (int c = 0; c < OBJ_NB; c++)
	{
		if (obj[c].type == OBJ_SPHERE)
			hit_sphere(ray, eyes, obj[c]);
		else if (obj[c].type == OBJ_PLAN)
			hit_plan(ray, eyes, obj[c]);	
	}
}

#define PH_AMBIENT		0.1
#define PH_DIFFUSE		0.8
#define PH_SPEC			0.5
#define PH_SHIN			10.0

vec4		light(vec4 color, vec3 ray, vec3 eyes, vec3 spot)
{
	float	theta, omega;
	vec3	l, r;
	vec4	spec	= vec4(1, 1, 1, 0);
	
	l = normalize(spot - work.point);
	theta = dot(work.normal, l);

	r = reflect(l, work.normal);
	ray = normalize(ray);
	omega = dot(r, ray);

	color = (color * PH_AMBIENT) + (color * PH_DIFFUSE * theta);
	if (omega > F_NULL)
	{
		spec = spec * PH_SPEC * pow(omega, PH_SHIN);
		color += spec;
	}
	return color;
}

vec4		shadow(vec4 color, vec3 spot)
{
	s_work	save;

	save = work;
	inter_obj(spot - work.point, work.point);
	if (work.flag == true && work.dis < 1.0)
	{
		work = save;
		color *= 0.5;
	}
	else
		work = save;
	return color;
}

vec4		illumination(vec4 color, vec3 ray, vec3 eyes, vec3 spot)
{
	color = light(color, ray, eyes, spot);
	color = shadow(color, spot);
	return color;
}

vec4		fog(vec4 color)
{
	float	alpha;
	
	alpha = exp(work.dis * -0.5);
	color = color * alpha + (1.0 - alpha) * 0.8;
	return color;
}

vec4		calc(vec3 ray, vec3 eyes, vec3 spot)
{
	vec4	color;
	float	tmp;
	int		c=0;
	s_obj	obj;
	const int clen = 2;
	color = vec4(0);
	for (int c = 0; c < clen; c++)
	{
		inter_obj(ray, eyes);
		if (work.flag == true)
		{
			if (c == 0)
				color = illumination(work.obj.color, ray, eyes, spot);
			else if (obj.reflect > F_NULL)
				color = illumination(work.obj.color, ray, eyes, spot) * obj.reflect + (1.0 - obj.reflect) * color;
			//fog();
			if (work.obj.reflect > F_NULL)
			{
				ray = reflect(ray, work.normal);
				eyes = work.point;
				obj = work.obj;
			}
			else
				break;
		}
		else
			break;
	}
	return color;
}

void		main(void)
{
	
	vec3	ray;
	vec3	eyes;
	vec3	spot;

	obj[0].type = OBJ_SPHERE;
	obj[0].pos = vec3(100.0,100.0,100.0 +  cos(time * 2.4) * 50.0) ;
	obj[0].rot = vec3(0, 0, 0);
	obj[0].color = vec4(0, 0.9, 0, 0);
	obj[0].reflect = -1.0;
	obj[0].refract = 0.25;
	obj[0].ray = 50.0 +  exp(1.0-mod(time/2.0,1.0)/1.0) * sin(time/2.0) * 20.0;
	
	obj[1].type = OBJ_SPHERE;
	obj[1].pos = vec3(100.0,-500.0,100.0); // + sin(time) * 40.0
	obj[1].rot = vec3(0, 0, 0);
	obj[1].color = vec4(0.2, 0.6, 0.6, 0);
	obj[1].reflect = -1.0;
	obj[1].refract = 0.25;
	obj[1].ray = 150.0;
	
	obj[2].type = OBJ_PLAN;
	obj[2].pos = vec3(0, 0, 0);
	obj[2].rot = vec3(0, 0, 0);
	obj[2].color = vec4(1, 1, 1, 0);
	obj[2].reflect = 0.5;
	obj[2].refract = -1.0;
	
	spot = vec3(-resolution.x/2., 0, resolution.y);
	ray = vec3(resolution.x, resolution.x / 2.0 - gl_FragCoord.x, -1.0 * (resolution.x / 2.0 - gl_FragCoord.y));
	eyes = vec3(-1800.0+ cos(time/4.0) * 800.0, -200.0 , 400.0 + sin(time/4.0) * 80.0);
	eyes = vec_rotate(eyes, vec3(0, 0, 0));
	
	gl_FragColor = calc(ray, eyes, spot);

}