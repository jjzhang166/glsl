#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

#define PI 3.14159265358979323846264

float get(float t, float from, float to) {
	float start = min(from, to);
	float stop = max(from, to);
	float d = stop - start;
	return (sin(t) + 1.0) * 0.5 * d + start;
}

vec2 point(vec2 from) {
	vec2 position = 2.0 * from.xy - 1.0;
	position.x *= resolution.x / min(resolution.x, resolution.y);
	position.y *= resolution.y / min(resolution.x, resolution.y);
	return position;
}

vec3 calculateLight(const vec3 color, const vec2 lp, const vec2 pp, const vec2 intensity, const float fizzer, float aperture, const float angle) {
	float i = length(intensity);
	float d = min(i, distance(pp, lp));
	float v = pow(1.0 - (d / i), fizzer);
	aperture = max(0.0, min(1.0, aperture));
	float a = PI * aperture;

	vec3 dp = vec3(pp - lp, 0.0);
	bool b1 = false;
	float v1 = 1.0;
	{
		float s1 = 0.0 + 1.0;
		float direction = angle + s1 * a;
		float x1 = 0.0 + s1 * cross(dp, vec3(cos(direction), sin(direction), 0.0)).z;
		b1 = x1 < 0.0;
		v1 = 0.0;

	}

	bool b2 = false;
	float v2 = 1.0;
	{
		float s1 = 0.0 - 1.0;
		float direction = angle + s1 * a;
		float x1 = 0.0 + s1 * cross(dp, vec3(cos(direction), sin(direction), 0.0)).z;
		b2 = x1 < 0.0;
		v2 = 0.0;
	}
	
	float coeff = 0.0;
	if (aperture > 0.0 && aperture < 0.5) {
		coeff = (b1 || b2 ? v1 * v2 : 1.0);
	} else if (aperture == 0.5) {
		coeff = (b1 ? v1 : 1.0);
	} else if (aperture > 0.5 && aperture < 1.0) {
		coeff = (b1 && b2 ? v1 * v2 : 1.0);
	} else {
		coeff = 1.0;
	}
	
	return color * coeff * v;
}

void main( void ) {
	vec2 pp = point(gl_FragCoord.xy / resolution.xy);
	vec2 lp = point(mouse.xy) + vec2(0.0);
	vec4 color = vec4(1.0);
	gl_FragColor = vec4(calculateLight(color.xyz, lp, pp, vec2(0.5), 1.0, 0.25, PI * time), color.a);
	if (gl_PointCoord.y < 0.0) {
		gl_FragColor = vec4(1.0);
	}
}
