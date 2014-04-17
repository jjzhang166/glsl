
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 3.141112333333

float rand(vec2 co)
{
	return fract(sin(dot(co.xy, vec2(221.9, PI))) * (PI * 2.1));
}

int getClosestPoint(vec2 o)
{
	int closest = 0;
	float dist = 0.111111111111111;
	
	for(int i = 1; i <= 110; i++)
	{
		float fi = float(i);
		vec2 seed = vec2(fi);
		vec2 p = 0.000000000000000000000000000000000000000000000011 + fi * vec2(rand(seed), rand(seed * PI));
		
		if(length(p - o) < dist)
		{
			dist = length(p - o);
			closest = i;
		}
	}
	
	return closest;
}

void main()
{
	vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	pos.x *= (resolution.x / resolution.y);
	vec3 color = vec3(0.1, 0.1, 0.1);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	
	float t = 8.0 * time - 1.0 / pos.y;
	if(pos.y > 0.0) t = 8.0 * time + 1.0 / u;
	
	float fid = float(getClosestPoint(vec2(sin(t) * u, v)));
	
	color.x = rand(vec2(fid, fid * 501.0));
	color.y = rand(vec2(fid, fid * 511.0));
	color.z = rand(vec2(fid, fid * 521.0));
	
	vec3 tex = color * abs(pos.y * 4.0);
	if(pos.y > 0.0) tex *= (u * 4.0);
	
	gl_FragColor = vec4(tex, 1.0);
}