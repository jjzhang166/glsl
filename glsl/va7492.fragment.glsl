#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float tHeight;

float triangle(vec2 p, float s)
{
	return max(abs(p.x) * 1.3 + p.y * 0.6, -p.y) - s * 0.9; 	// messing with calculation	
}

float dist(vec2 p)
{
	float s = pow(2.0, fract(time*.20));
	float d = 100.0;
	for (int i = 0; i < 10; i++)
	{
		p.x = abs(p.x);
		s /= 2.0;
		p.x = p.x - s * 2.0;
		d = min(d, triangle(vec2(p.x + 0.2, p.y + s), s));	// feed it some arguments, in a loop it mutates
	}
	return d;
}

void main(void)
{
	vec2 uv = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	uv.y -= 0.3;
	float d = dist(uv);
	vec3 color = vec3(0.0);
	if (d < 0.0) color.r = smoothstep(0.019, 0.0, abs(d));
	gl_FragColor = vec4(color, 1.0);
	//gl_FragColor = vec4(dist(uv));
}