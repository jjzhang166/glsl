#ifdef GL_ES
precision mediump float;
#endif

// All Hail Spaghetti!
// iichan.hk/dev

const float PID2 = 3.14/2.0;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool six(vec2 pos)
{
	vec2 ipos = 2.0 * pos - vec2(1.0);
	bool s1, s2;
	{
		vec2 rp = ipos * vec2(1.0, 1.3) + vec2(0.0, 0.5);
		float x = dot(rp, rp);
		s1 = (x > 0.28) && (x < 0.5);
	}
	{
		vec2 rp = ipos * vec2(1.0, 1.1) - vec2(0.0, 0.4);
		float x = dot(rp, rp);
		s2 = (x > 0.28) && (x < 0.5) && (rp.y > 0.0);
	}
	bool s3 = (pos.x > 0.146) && (pos.x < 0.235) && (pos.y > 0.33) && (pos.y < 0.69);
	return s1 || s2 || s3;
}

float digit(vec2 pos, int d)
{
	if ((pos.x < 0.0) || (pos.y < 0.0) || (pos.x > 1.0) || (pos.y > 1.0))
		return 0.0;

	bool on = false;
	vec2 ipos = 2.0 * pos - vec2(1.0);
	if (d == 0)
	{
		vec2 rp = ipos * vec2(1.5, 1.0);
		float x = dot(rp, rp);
		on = (x > 0.65) && (x < 1.0);
	} else
	if (d == 1)
	{
		float t = pos.y - pos.x;
		bool s1 = (pos.x > 0.3) && (pos.x < 0.55) && (t > 0.4) && (t < 0.55);
		bool s2 = (pos.x > 0.45) && (pos.x < 0.55);
		on = s1 || s2;
	} else
	if (d == 2)
	{
		bool s1, s2;
		{
			vec2 rp = ipos - vec2(0.0, 0.35);
			float x = dot(rp, rp);
			s1 = (atan(rp.x, rp.y) > -PID2) && (x > 0.2) && (x < 0.35);
		}
		{
			vec2 rp = ipos + vec2(0.0, 0.69);
			float x = dot(rp, rp);
			float a = atan(rp.x, rp.y);
			s2 = (a < 0.0) && (a > -PID2) && (x > 0.2) && (x < 0.35);
		}
		bool s3 = (pos.x > 0.2055) && (pos.x < 0.79) && (pos.y < 0.16) && (pos.y > 0.05);
		on = s1 || s2 || s3;
	} else
	if (d == 3)
	{
		bool s1, s2;
		{
			vec2 rp = vec2(1.0, 1.3) * ipos - vec2(0.0, 0.65);
			float x = dot(rp, rp);
			s1 = ((rp.x > 0.0) || (rp.y > 0.0)) && (x > 0.2) && (x < 0.4);
		}
		{
			vec2 rp = vec2(1.0, 1.1) * ipos + vec2(0.0, 0.45);
			float x = dot(rp, rp);
			s2 = ((rp.x > 0.0) || (rp.y < 0.0)) && (x > 0.2) && (x < 0.4);
		}
		on = s1 || s2;
	} else
	if (d == 4)
	{
		float x1 = 2.2 * pos.x - pos.y;
		bool s1 = (x1 > 0.05) && (x1 < 0.25) && (pos.x > 0.2);
		bool s2 = (pos.x > 0.2) && (pos.x < 0.7) && (pos.y > 0.2) && (pos.y < 0.35);
		bool s3 = (pos.x > 0.5) && (pos.x < 0.6);
		on = s1 || s2 || s3;
	} else
	if (d == 5)
	{
		vec2 rp = ipos * vec2(1.0, 1.3) + vec2(0.0, 0.5);
		float x = dot(rp, rp);
		bool s1 = (rp.x > -0.5) && (x > 0.28) && (x < 0.5);
		bool s2 = (pos.x > 0.25) && (pos.x < 0.3) && (pos.y > 0.5);
		bool s3 = (pos.x > 0.25) && (pos.x < 0.82) && (pos.y > 0.92);
		on = s1 || s2 || s3;
	} else
	if (d == 6) on = six(pos); else
	if (d == 7)
	{
		float x = 2.5 * pos.x - pos.y;
		bool s1 = (x > 0.7) && (x < 0.9);
		bool s2 = (pos.x > 0.25) && (pos.x < 0.7) && (pos.y > 0.9);
		on = s1 || s2;
	} else
	if (d == 8)
	{
		bool s1, s2;
		{
			vec2 rp = vec2(1.4, 1.8) * ipos - vec2(0.0, 0.92);
			float x = dot(rp, rp);
			s1 = (x > 0.4) && (x < 0.65);
		}
		{
			vec2 rp = vec2(1.0, 1.2) * ipos + vec2(0.0, 0.5);
			float x = dot(rp, rp);
			s2 = (x > 0.3) && (x < 0.48);
		}
		on = s1 || s2;
	} else
		on = six(vec2(1.0) - pos);
		
	return on ? 34.0 : 0.0;
}

float point(vec2 pos)
{
	return (dot(pos, pos) < 0.0005) ? 1.0 : 0.0;
}

const vec3 color_st = vec3(1.0, 0.0, 0.0);
const vec3 color_s = vec3(1.0, 0.0, 0.0);
const vec3 color_mst = vec3(0.0, 0.2, 1.0);
const vec3 color_ms = vec3(0.0, 0.2, 1.0);

const vec3 color_point = vec3(0.0, 1.0, 0.0);

void main(void)
{
	vec2 position = gl_FragCoord.xy / resolution.y;

	vec2 rect_st = (position - vec2(0.35, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_s = (position - vec2(0.6, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_mst = (position - vec2(0.95, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_ms = (position - vec2(1.2, 0.3)) * vec2(4.0, 3.0);

	int d_st = int(mod(time * 0.1, 10.0));
	int d_s = int(mod(time, 10.0));
	int d_mst = int(mod(time * 10.0, 10.0));
	int d_ms = int(mod(time * 100.0, 10.0));
	
	float k_st = 1.0 - 0.5 * mod(time, 10.0) * 0.1;
	float k_s = 1.0 - 0.5 * mod(time * 10.0, 10.0) * 0.1;
	
	float point_blink = smoothstep(0.0, 1.0, 2.0 * abs(mod(time, 1.0) - 0.5));
	vec3 color = 
		k_st * digit(rect_st, d_st) * color_st +
		k_s * digit(rect_s, d_s) * color_s +
		digit(rect_mst, d_mst) * color_mst +
		digit(rect_ms, d_ms) * color_ms +
		point_blink * point(position - vec2(0.9, 0.55)) * color_point +
		(1.0 - point_blink) * point(position - vec2(0.9, 0.4)) * color_point;
	gl_FragColor = vec4(color, 1.0);
}