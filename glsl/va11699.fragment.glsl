#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float eps = .0001;

float rand(vec2 co){
	return step(fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453),0.5);
}

vec4 get(vec2 p)
{
	return texture2D(backbuffer,mod(p/resolution,1.0)).rgba;
}

float neighbors(vec2 p)
{
	float n = 0.0;
	n += get(p+vec2( 1, 0)).a;
	n += get(p+vec2(-1, 0)).a;
	n += get(p+vec2( 0, 1)).a;
	n += get(p+vec2( 0,-1)).a;
	n += get(p+vec2( 1, 1)).a;
	n += get(p+vec2(-1, 1)).a;
	n += get(p+vec2( 1,-1)).a;
	n += get(p+vec2(-1,-1)).a;
	return n;
}

void main( void ) {

	vec2 p = gl_FragCoord.xy;
	
	float c = get(p).a;
	
	float n = neighbors(p);
	
	c = (step(n,3.0+eps)-step(n,2.0-eps))*c;
	c += step(n,3.0+eps)-step(n,3.0-eps);
	
	c += step(distance(p,mouse*resolution),8.0)*rand(p+time);
	c = sign(c);	
	
	gl_FragColor = vec4( vec3( c+n/16. ,n/8.,0.), c );
}