precision mediump float;

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

//ok i give up

float segm(float size, float xy)
{
	return abs(abs(xy) - size);	
}

float rect(vec2 pos)
{
	float dist = 0.0;
	dist = max((segm(0.0, pos.x)) , (segm(0.0, pos.y)));
    	return dist;
}

float shad(vec2 pos)
{
	float dist = 0.0;
	dist = max(pow((segm(0.0, pos.x)), 2.0) , pow((segm(0.0, pos.y)), 2.0));
    	return dist;
}
vec3 gradient(float y)
{
	return vec3(mix(vec3(0.0, 0.45, 1.0), vec3(0.0, 0.75, 1.0), y * 5.0 + 0.5));	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	{
		float t0 = 10.0 * time, t1 = 4.0 * time, c = cos(t1), s = sin(t1);
		position = position * vec2(resolution.x / resolution.y, 1.0) * (sin(t0) * 0.5 - 0.8);
		position = vec2(dot(vec2(c, -s), position), dot(vec2(s, c), position));
	}
	vec2 m = mouse * 2.0 - 1.0;
	m.x *= 0.5;
	position.x *= 0.5;
	float dist = rect(position);
	vec3 color = vec3(1.02);
	if(dist < 0.1)
	{
		color = gradient((position.y));
		if(rect(m) < 0.1)
		{
			color += 0.076;	
		}
	}
	else
	{
		color *= min(0.8, shad(position * 8.0));	
	}
	
	gl_FragColor = vec4(color, 2.0);
	
}