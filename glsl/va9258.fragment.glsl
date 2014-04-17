#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D bb;

float get(vec2 p){return texture2D(bb,mod(p/resolution,1.)).a;}

float ne(vec2 p)
{
	return get(p+vec2(0,1))+get(p+vec2(0,-1))+get(p+vec2(-1,0))+get(p+vec2(1,0))+
	       get(p+vec2(-1,-1))+get(p+vec2(-1,1))+get(p+vec2(1,1))+get(p+vec2(1,-1));
}

float life(vec2 p)
{
	float c = get(p);
	float n = ne(p);
	
	c = ((n == 2. || n == 3.) && c == 1.) ? c : 0.;
	c = (n == 3.) ? 1. : c;
	
	return c;
}

void main( void ) 
{
	vec2 p = gl_FragCoord.xy;

	float cell = life(p);	
	
	if(distance(mouse*resolution,p) < 8.) cell = 1.;
	
	gl_FragColor = vec4( vec3( cell ), cell);
}