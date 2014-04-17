
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 hash(vec2 p)
{
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453);
}

// voronoi cell id noise
vec3 voronoi(in vec2 x)
{
	vec2 n = floor(x);
	vec2 f = fract(x);

	vec2 mg, mr;
	
	float md = 8.0;
	for(int j = -1; j <= 1; j ++)
	{
		for(int i = -1; i <= 1; i ++)
		{
			vec2 g = vec2(float(i),float(j));
			vec2 o = hash(n + g);
			vec2 r = g + o - f;
			float d = max(abs(r.x), abs(r.y));
			
			if(d < md)
			{
				md = d;
				mr = r;
				mg = g;
			}
		}
	}
	
	return vec3(n + mg, mr);
}

float stepfunc(float a)
{
	return step(a, 0.0);
}

float fan(vec2 p, vec2 at, float size, float ang)
{
	p -= at;
	p *= 3.0;
	
	float v = 0.0, w, a;
	float le = length(p);
	
	v = le - 1.0;
	
	if(v > 0.0)
		return 0.0;
	
	a = sin(atan(p.y, p.x) * 3.0 + ang);
	
	w = le - 0.05 * size;
	v = max(v, -(w + a * 0.8));
	
	w = le - 0.15 * size;
	v = max(v, -w);
	
	return stepfunc(v);
}

float gear(vec2 p, vec2 at, float teeth, float size, float ang)
{
	p -= at;
	float v = 0.0, w;
	float le = length(p);
	
	w = le - 0.3 * size;
	v = w;
	
	w = sin(atan(p.y, p.x) * teeth + ang);
	w = smoothstep(-0.7, 0.7, w) * 0.1;
	v = min(v, v - w);
	
	w = le - 0.05;
	v = max(v, -w);
	
	return stepfunc(v);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5 + mouse / 4.0;

	float v = 0.0; 
	v = max(v, fan(position, vec2(0.2,0.2), 0.5, time));
	v = max(v, gear(position, vec2(-0.2,0.2), 8.0, 0.2, time));
	gl_FragColor = vec4(v);
	//gl_FragColor = vec4(voronoi(position.xy*10.0), 0.0);
}
