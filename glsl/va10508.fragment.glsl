#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdCircle(vec2 p, vec2 t, float r)
{
	return length(t-p) - r;
}

float sdRect(vec2 p, vec2 a, vec2 b)
{
	return -min( min( min( -a.y+p.y, b.y-p.y ), -a.x+p.x), b.x-p.x);
}

float sdStroke(vec2 p, vec2 a, vec2 b)
{
	float l = length(a - b);
	float l2 = l*l;

	if (l2 == 0.0) return distance(p, a);	
	float t = dot(p-a, b-a) / l2;
	if (t < 0.0) return distance(p, a);
  	else if (t > 1.0) return distance(p, b);
  	vec2 prj = a + t * (b - a);
	
	float dp = distance(a, prj) / l;
	
	return distance(p, prj) + (dp+0.5) * (dp+0.5);
}

float ding(vec2 p)
{
	return 0.0;
}

void main( void ) 
{

	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
	
	float c = (sdStroke(p, vec2(-0.5), m) < 0.05) ? 1.0 : 0.0;
	//float c = sdStroke(p, vec2(-0.5), m, 0.05);
	
	gl_FragColor = vec4(vec3(c), 1.0);
}