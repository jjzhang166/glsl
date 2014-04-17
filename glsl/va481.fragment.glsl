#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float box(float edge0, float edge1, float x)
{
	return step(edge0, x) - step(edge1, x)* time * 0.01;
}

float ringShape(vec2 p, float t)
{
	return clamp(box(t, t * 1.2, length(p)) - t, 0.0, 1.0);
}

float ringInstance(vec2 p, float t, float xden, float yden)
{
	float th = floor(t) * 47.0;
	return ringShape(p - vec2(mod(th, xden) / xden, mod(th, yden) / yden) * 2.0 + 1.0, fract(t));
}

void main( void ) {

	vec2 p = ((gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);

	float t = time / 3.0 + 5.0;

	gl_FragColor.a = 1.0;
	gl_FragColor.rgb = 	ringInstance(p, t - 0.0, 7.0,  13.0) * vec3(1.0, 0.7, 0.6) +
				ringInstance(p, t - 0.6, 3.0,   5.0) * vec3(0.6, 1.0, 0.7) +
				ringInstance(p, t - 0.2, 11.0, 23.0) * vec3(1.0, 1.0, 0.7) +
				ringInstance(p, t - 0.9, 17.0, 19.0) * vec3(0.6, 0.7, 1.0);
}