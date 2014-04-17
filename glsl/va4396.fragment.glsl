#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159

#define MAX_ITER 100
#define MAX_DIST 100.0
#define EPS_DIST 0.01
#define EPS_GRAD 0.01

float ud_box(in vec3 p, in vec3 e)
{
	return length(max(abs(p)-e, 0.0));
}

float ud_box_round(in vec3 p, in vec3 e, in float r)
{
	return ud_box(p, e) - r;
}

float scene(in vec3 p)
{
	vec3 q = mod(p, 1.0);
	return ud_box_round(q, vec3(0.02, 0.02, 0.02), 0.005);
}

vec3 gradient(in vec3 p)
{
	vec3 dx = vec3(EPS_GRAD, 0.0, 0.0);
	vec3 dy = vec3(0.0, EPS_GRAD, 0.0);
	vec3 dz = vec3(0.0, 0.0, EPS_GRAD);
	
	return vec3(
		scene(p+dx) - scene(p-dx),
		scene(p+dy) - scene(p-dy),
		scene(p+dz) - scene(p-dz)
	);
}

float shadow(in vec3 p, in vec3 v, in float s, in float k)
{
	float a = 1.0;
	float t = 10.0 * EPS_DIST;
	float d;
	
	for (int i = 0; i < MAX_ITER; i++)
	{
		if (a != 0.0 && t < s)
		{
			d = scene(p + v*t);
			
			if (d <= EPS_DIST)
			{
				a = 0.0;
			}

			a = min(a, k*(d/t));
			t += d;
		}
	}
	
	return 1.0-a;
}

void render(in vec3 p, in vec3 v, in vec3 pL, out vec4 c)
{
	float d;
	float dL;
	
	vec3 L;
	vec3 N;
	vec3 V = -v;
	vec3 R;
	
	vec3 Ia;
	vec3 Id;
	vec3 Is;
	float kS = 20.0;
	
	for (int i = 0; i < MAX_ITER; i++)
	{
		if (c.a == 0.0)
		{
			d = scene(p);
			
			if (d <= EPS_DIST)
			{
				dL = distance(p, pL);
				
				L = (pL-p) / dL;
				N = normalize(gradient(p));
				R = reflect(-L, N);
				
				Ia = vec3(0.1, 0.1, 0.1);
				Id = vec3(0.5, 0.5, 0.5) * max(0.0, dot(N, L));
				Is = vec3(1.0, 0.7, 0.5) * pow(max(0.0, dot(R, V)), kS);
				
				//c.rgb = Ia + Id + Is;
				c.rgb = Ia + (1.0 - shadow(p, L, dL, 8.0)) * (Id + Is);
				c.a = 1.0;
			}
			
			p += d * v;
		}
	}
}

void main()
{
	float ey = tan(0.25 * PI);
	float ex = ey * (resolution.x / resolution.y);
	
	float py = ey * (gl_FragCoord.y / resolution.y - 0.5);
	float px = ex * (gl_FragCoord.x / resolution.x - 0.5);
	
	vec3 p = vec3(px, py, -1.0);
	vec3 v = normalize(p);
	
	vec3 pL = vec3(5.0*sin(time), 10.0, 5.0+5.0*cos(time));
	
	render(p, v, pL, gl_FragColor);	
}