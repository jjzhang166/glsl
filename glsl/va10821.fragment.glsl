#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define iter 10
#define speed 0.25
#define grid 20.0
#define scale 1.3

/*
#define iter 150
#define speed 0.1
#define grid 4.0
#define scale 0.8
*/

void main()
{
	vec2 uv = scale * gl_FragCoord.xy / max(resolution.x, resolution.y);
	float t = time * speed;
	vec2 p = uv;
	for(int i=1; i<=iter; ++i)
	{
		vec2 np = p;
		np.x += .5/float(i)*cos(float(i)*p.y+t) - 1.0;
		np.y += .5/float(i)*sin(float(i)*p.x+t) + 1.0;
		p=np;
	}
	gl_FragColor = vec4(cos(grid*p), sin(grid*(p.x + p.y)), 1.0);
}
