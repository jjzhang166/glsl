#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D last;

//Sub-pixel game of life test
//not working right yet

struct neighbors
{
	vec3 c;
	vec3 u;
	vec3 d;
	vec3 l;
	vec3 r;
	vec3 ul;
	vec3 ur;
	vec3 dl;
	vec3 dr;
};
	
neighbors getNeighborhood(vec2 p)
{
	vec2 r = resolution;
	return neighbors
	(
		texture2D(last,p/r).rgb,
		texture2D(last,(p+vec2(0,1))/r).rgb,
		texture2D(last,(p+vec2(0,-1))/r).rgb,
		texture2D(last,(p+vec2(-1,0))/r).rgb,
		texture2D(last,(p+vec2(1,0))/r).rgb,
		texture2D(last,(p+vec2(-1,1))/r).rgb,
		texture2D(last,(p+vec2(1,1))/r).rgb,
		texture2D(last,(p+vec2(-1,-1))/r).rgb,
		texture2D(last,(p+vec2(1,-1))/r).rgb
	);
}
	
vec3 ne(vec2 p)
{
	vec3 t;
	neighbors n = getNeighborhood(p);
	
	t.r += n.u.r;
	t.r += n.d.r;
	t.r += n.l.b;
	t.r += n.c.g;
	t.r += n.ul.b;
	t.r += n.u.g;
	t.r += n.dl.b;
	t.r += n.d.g;

	t.g += n.u.g;
	t.g += n.d.g;
	t.g += n.c.r;
	t.g += n.c.b;
	t.g += n.u.r;
	t.g += n.u.b;
	t.g += n.d.r;
	t.g += n.d.b;

	t.b += n.u.b;
	t.b += n.d.b;
	t.b += n.c.g;
	t.b += n.l.r;
	t.b += n.u.g;
	t.b += n.ur.r;
	t.b += n.d.g;
	t.b += n.dl.r;
	
	return t;
}
	
float rand(vec2 co)
{
    return floor(fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453)+.5);
}
	
void main( void ) {

	vec2 p = gl_FragCoord.xy;
	
	vec3 c = texture2D(last,p/resolution).rgb;
		
	vec3 nc = ne(p);
	
	vec3 fc = vec3(0);
	
	if((nc.r == 3. || nc.r == 2.) && c.r == 1.)
	{
		fc.r = 1.;
	}
	if(nc.r == 3.)
	{
		fc.r = 1.;
	}
	
	if((nc.g == 3. || nc.g == 2.) && c.g == 1.)
	{
		fc.g = 1.;
	}
	if(nc.g == 3.)
	{
		fc.g = 1.;
	}
	
	if((nc.b == 3. || nc.b == 2.) && c.b == 1.)
	{
		fc.b = 1.;
	}
	if(nc.b == 3.)
	{
		fc.b = 1.;
	}
	
	if(distance(mouse*resolution,p) < 16.)
	{
		fc = vec3(rand(p),rand(p-0.2),rand(p+0.84));
	}
	
	gl_FragColor = vec4( vec3( fc ), 1.0 );

}