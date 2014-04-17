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

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5 + mouse / 4.0;

	gl_FragColor = vec4(voronoi(position.xy*10.0), 0.0);
}