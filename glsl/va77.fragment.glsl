#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 ro, vec3 rd, vec3 center, float radius)
{
	vec3 ro2 = ro - center;
	float a = dot(rd, rd);
	float b = 2.0 * dot(rd, ro2);
	float c = dot(ro2, ro2) - radius*radius;
	float discriminant = b*b - 4.0*a*c;
	if (discriminant < 0.0) return 99999.;
	float s1 = (-b + sqrt(discriminant))/(2.*a);
	float s2 = (-b - sqrt(discriminant))/(2.*a);
	float result = min(s1, s2);
	if (result < 0.0) return 99999.;
	else return result;
}