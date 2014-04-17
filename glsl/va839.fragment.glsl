// Dark Chocolate Plasma by Optimus

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int iters = 256;

const float origin_z = 0.0;
const float plane_z = 4.0;
const float far_z = 64.0;

const float step = (far_z - plane_z) / float(iters) * 0.025;

const float color_bound = 0.0;
const float upper_bound = 1.0;

const float scale = 32.0;

const float disp = 0.25;

float calc_this(vec3 p, float disx, float disy, float disz)
{
	float c = sin(sin((p.x + disx) * sin(sin(p.z + disz)) + time) + sin((p.y + disy) * cos(p.z + disz) + 2.0 * time) + sin(3.0*p.z + disz + 3.5 * time) + sin((p.x + disx) + sin(p.y + disy + 2.5 * (p.z + disz - time) + 1.75 * time) - 0.5 * time));
	return c;
}

vec3 get_intersection()
{
	vec2 position = (gl_FragCoord.xy / resolution.xy - 0.5) * scale;

	vec3 pos = vec3(position.x, position.y, plane_z);
	vec3 origin = vec3(0.0, 0.0, origin_z);

	vec3 dir = pos - origin;
	vec3 dirstep = normalize(dir) * step;

	dir = normalize(dir) * plane_z;


	float c;

	for (int i=0; i<iters; i++)
	{
		c = calc_this(dir, 0.0, 0.0, 0.0);

		if (c > color_bound)
		{
			break;
		}

		dir = dir + dirstep;
	}

	return dir;
}


void main()
{
	vec3 p = get_intersection();
	float dx = color_bound - calc_this(p, disp, 0.0, 0.0);
	float dy = color_bound - calc_this(p, 0.0, disp, 0.0);

	vec3 du = vec3(disp, 0.0, dx);
	vec3 dv = vec3(0.0, disp, dy);
	vec3 normal = normalize(cross(du, dv));

	vec3 light = normalize(vec3(0.0, 0.0, 1.0));
	float l = dot(normal, light);

	float cc = pow(l, 2.0);
	gl_FragColor = vec4(cc*0.8, cc*0.5, cc*0.2, cc);
}
