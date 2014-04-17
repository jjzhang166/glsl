// rotwang: @mod* just playing

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float rand(vec2 co)
{
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

int getClosestPoint(vec2 o)
{
	int closest = 0;
	float dist = 4.0;
	
	for(int i = 1; i <= 100; i++)
	{
		float fi = float(i);
		vec2 seed = vec2(fi);
		vec2 p = -1.0 + 2.0 * vec2(rand(seed), rand(seed * 125.0));
		
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
	
	
	float u = length(pos);
	float v = atan(pos.y, pos.x)/6.28;
	
	float t =  time  / pos.y;
	if(pos.y > 0.0)
		t =  time + 2.0 / u;
	
	float fid = float(getClosestPoint(vec2(sin(t) * u, v)));
	
	float hue = rand(vec2(fid, fid * 51.0));
	float sat = 0.25 * rand(vec2(fid, fid * 52.0));
	float lum = rand(vec2(fid, fid * 53.0));
	
	vec3 color = hsv2rgb(hue, sat, lum);
		 
	vec3 tex = color * abs(pos.y * 3.0);
	if(pos.y > 0.0)
		tex *= (u * 2.0);
	tex *= 1.5-u;
	gl_FragColor = vec4(tex, 1.0);
}