#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float segmentShape(vec2 p, vec2 s0, vec2 s1, float radius)
{
	vec2 d = normalize(s1 - s0);
	float slen = distance(s0, s1);

	float 	d0 = max(abs(dot(p - s0, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(p - s0, d) - slen * 0.5) - slen * 0.5, 0.0);

	float len = length(vec2(d0, d1));
	return smoothstep(0.025, radius, len);
}

vec2 sequence(float t)
{
	return vec2( mod((t * 1721.0) / 7.0, 1.0), mod((t * 1669.0) / 13.0, 1.0)) - vec2(0.5);
}

float snakeShape(vec2 p, float t)
{
	float ti = floor(t),
		radius = 0.02,
		m = fract(t);

	vec2 	sp0 = sequence(ti),
		sp1 = sequence(ti - 1.0),
		sp2 = sequence(ti - 2.0),
		sp3 = sequence(ti - 3.0);

	float 	a = segmentShape(p, sp1, mix(sp2,sp1,m), radius),
		b = segmentShape(p, sp1, sp2, radius),
		
		c = segmentShape(p, sp2, mix(sp3,sp1,m), radius);
	
	return clamp(a+b+c, 0.0, 1.0);
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5)) * vec2(resolution.x / resolution.y, 1.0);

	gl_FragColor.a = 1.0;
	float len = time+100.0;
	
	float shape = snakeShape(p, len);
	vec3 rgb = vec3(0.99, 0.6, 0.2)*shape;
	gl_FragColor = vec4(  rgb, 1.0);
}