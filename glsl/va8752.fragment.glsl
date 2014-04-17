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
	{
		float x = pos.x, y = pos.y;
		bool s1 = (x > 0.15) && (x < 0.25) && ( y > 0.55 ) && ( y < 0.90 );
		bool s2 = (x > 0.15) && (x < 0.25) && ( y < 0.45 ) && ( y > 0.10 );
		bool s3 = (x > 0.75) && (x < 0.85) && ( y > 0.55 ) && ( y < 0.90 );
		bool s4 = (x > 0.75) && (x < 0.85) && ( y < 0.45 ) && ( y > 0.10 );
		bool s5 = (y > 0.00) && (y < 0.10) && ( x > 0.20 ) && ( x < 0.80 );
		bool s6 = (y > 0.45) && (y < 0.55) && ( x > 0.20 ) && ( x < 0.80 );
		bool s7 = (y > 0.90) && (y < 1.00) && ( x > 0.20 ) && ( x < 0.80 );
		s1 = s1 && (d==0||d==4||d==5||d==6||d==8||d==9);
		s2 = s2 && (d==0||d==2||d==6||d==8);
		s3 = s3 && (d!=5&&d!=6);
		s4 = s4 && (d!=2);
		s5 = s5 && (d!=1&&d!=4&&d!=7);
		s6 = s6 && (d!=0&&d!=1&&d!=7);
		s7 = s7 && (d!=1&&d!=4);
		on = s1 || s2 || s3 || s4 || s5 || s6 || s7;
	}
	return on ? 1.0 : 0.0;
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