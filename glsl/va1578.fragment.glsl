// Life by @Kjell

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float u = 1.0 / resolution.x;
float v = 1.0 / resolution.y;

bool pointRect(vec2 point, vec4 rect)
{
	if(point.x < rect.x)return false;
	if(point.x > rect.z)return false;
	if(point.y < rect.y)return false;
	if(point.y > rect.w)return false;
	
	return true;
}

void main()
{
	float cell = 0.0;
	
	vec2 pixel = gl_FragCoord.xy - 0.5;
	vec2 coord = gl_FragCoord.xy / resolution;
	
	vec2 point = floor(mouse * resolution);	
	vec4 stamp = vec4(point.x - 1.0, point.y - 1.0, point.x + 1.0, point.y + 1.0);
	
	if(pointRect(pixel, stamp))
	{
		cell = fract((pixel.x + pixel.y) * 0.5) * 2.0;
	}
	else
	{
		int neighbours = 0;
		
		if(texture2D(backbuffer, coord + vec2(  u, 0.0)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2(  u,   v)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2(0.0,   v)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2( -u,   v)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2( -u, 0.0)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2( -u,  -v)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2(0.0,  -v)).a == 1.0)neighbours++;
		if(texture2D(backbuffer, coord + vec2(  u,  -v)).a == 1.0)neighbours++;
		
		if(texture2D(backbuffer, coord).a == 1.0)
		{
			if(neighbours > 1 && neighbours < 4)cell = 1.0;
		}
		else
		{
			if(neighbours == 3)cell = 1.0;
		}
	}
	
	gl_FragColor = vec4(cell);
}