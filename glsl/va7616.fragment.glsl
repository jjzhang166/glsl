#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float triangle(vec2 p, float s)
{
	return max(abs(p.x) * p.y * (1.0), -p.y) - s * 0.0009;
}

float dist(vec2 p)
{
	float s = 1.33333;//fract(time));
	float d;
	for (int i = 0; i < 118; i++)
	{
		p.x = abs(p.x);
		s /= sqrt(2.);
		p.x = p.x - s * sqrt(2.);
		d = min(d, triangle(vec2(p.x, p.y + s), s));
	}
	return d;
}

void main(void)
{
	vec2 uv =  0.5-gl_FragCoord.xy / (resolution.xy/2.);
	uv.y -= uv.y/1.33;
	float d = dist(uv*sqrt(6.28));
	vec3 color = vec3(1.0);
	if (d < 0.0) color.rgb -= smoothstep(0.1, 0.0, d);
	gl_FragColor = vec4(color.yzx * vec3(0.5, 0.2, 0.3), 1.0);
	//gl_FragColor = vec4(dist(uv));
}