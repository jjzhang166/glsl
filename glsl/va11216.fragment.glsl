#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float c_dist(vec2 f)
{
	return abs(f.x) + abs(f.y);
//	return length(f);
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

		
	uv.x *= resolution.x / resolution.y;

	uv *= 3.0;
	uv = mod(uv, vec2(1.0, 1.0));
	
	uv -= vec2(0.5, 0.5);	
	

	gl_FragColor = vec4(0.0);
	
	float dist = 1000.0;
	int num = -1;
	
	for (int i = 0; i < 16
	     ; i++)
	{
		float ang = float(i) * 1.1 + time * 0.6;
		float x = sin(ang * 1.5) * 0.4 + sin(ang * 4.342) * 0.2;
		float y = cos(ang * 1.3) * 0.4 + cos(ang * 2.3613) * 0.2;

		x += sin(ang * 7.71234) * 0.1 + sin(ang * 1.3234) * 0.3;
		y += cos(ang * 5.41235) * 0.1 + cos(ang * 2.3643) * 0.3;
		
		vec2 part = uv - vec2(x, y) * 0.5;
		if (length(part) < 0.03)
			gl_FragColor.b = 1.0;
		

		float this_dist = 1000.0;
		
		this_dist = min(this_dist, c_dist(part + vec2(0.0, 0.0)));
		this_dist = min(this_dist, c_dist(part + vec2(1.0, 0.0)));
		this_dist = min(this_dist, c_dist(part + vec2(-1.0, 0.0)));
		this_dist = min(this_dist, c_dist(part + vec2(0.0, 1.0)));
		this_dist = min(this_dist, c_dist(part + vec2(0.0, -1.0)));
		
		if (this_dist < dist)
		{
			dist = this_dist;
			num = i;
		}
		
	}
	gl_FragColor.g = float(num) / 16.0;
	gl_FragColor.r = 1.0 - pow(dist, 0.3);
}