#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float innerR;
uniform float innerG;
uniform float innerB;

uniform float outlineR;
uniform float outlineG;
uniform float outlineB;

uniform float bgR;
uniform float bgG;
uniform float bgB;

// named things _knaut

float triangle(vec2 p, float s)
{
	return max(abs(p.x) * 0.866025 + p.y * 0.5, -p.y) - s * 0.5;
}

float dist(vec2 p)
{
	float s = pow(2.0, fract(time));
	float d = 100.0;
	for (int i = 0; i < 10; i++)
	{
		p.x = abs(p.x);
		s /= 2.0;
		p.x = p.x - s * 2.0;
		d = min(d, triangle(vec2(p.x, p.y + s), s));
	}
	return d;
}

void main(void)
{
	float bgR = 0.0;
	float bgG = 0.0;
	float bgB = 0.0;
	
	float outlineR = 0.01;
	float outlineG = 0.02;
	float outlineB = 0.01;
	
	float innerR = 0.0101;
	float innerG = 0.02;
	float innerB = 0.1;
	
	vec2 uv = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	//uv.y -= 1.0;
	float d = dist(uv);
	vec3 color = vec3(bgR, bgG, bgB);
	if (d < 0.0) color.r = smoothstep(outlineR, innerR, abs(d));
	if (d < 0.0) color.g = smoothstep(outlineG, innerG, abs(d));
	if (d < 0.0) color.b = smoothstep(outlineB, innerB, abs(d));
	gl_FragColor = vec4(color, 1.0);
	//gl_FragColor = vec4(dist(uv));
}