#ifdef GL_ES
precision mediump float;
#endif

//library

//public domain

//please feel free to extend / unbreak what I mssed up
//shit is blowin up outside and I'm gonna go watch

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
varying vec2 surfacePosition;

#define sp surfacePosition

#define uv (gl_FragCoord.xy / resolution.xy)
#define m mouse
#define md length(uv-m)

#define uvw vec3((gl_FragCoord.xy - resolution*.5) / min(resolution.y,resolution.x) * 1.5, length((gl_FragCoord.xy - resolution * .5)) / min(resolution.y, resolution.x))
#define mw  vec3( (resolution * m - resolution*.5) / min(resolution.y,resolution.x) * 1.5, length(((resolution * m) - resolution * .5)) / min(resolution.y, resolution.x))
#define mdw length(uvw-mw)

#define origin vec2(0.)
#define center vec2(.5)

#define PI  4.*atan(1.) 
#define TAU 2.*PI

//functions
float circle(vec2 p, float r);
float sdfLine(vec2 a, vec2 b);
float sdfLine(vec3 a, vec3 b);
float line(vec2 a, vec2 b, float w);
float line(vec3 a, vec3 b, float w);
vec4 write(vec4 v, vec2 a);
vec4 read(vec2 a);

//vars
//rotation matrix (by iq?) - need to verify proper mouse hookup
float mx = sin(1.32 + mouse.x * 0.00037312) * 1.45 + 0.5;
float my = cos(1.01 + mouse.y * 0.00023312) * 1.45 + 0.5;
float c1 = cos(my * TAU);
float s1 = sin(my * TAU);
float c2 = cos(mx * TAU);
float s2 = sin(mx * TAU);
float c3 = cos(TAU);
float s3 = sin(TAU);

mat3 rotmat = 
	mat3(
		c1 ,-s1 , 0.0, 
		s1 , c1 , 0.0, 
		0.0, 0.0, 1.0
	) * mat3(
		1.0,0.0, 0.0, 
		0.0,c2 ,-s2 ,
		0.0,s2 , c2 
	) * mat3(
		c3,0.0,-s3,
		0.0, 1.0, 0.0,
		s3, 0.0,c3
	);

void main( void ) {
	
	float c0 = circle(vec2(m), 0.01);
	float l0 = line(vec2(1.), vec2(m), 0.004);
	float l1 = line(vec3(mw), vec3(0), 0.004);
	
	float r = l0 + l1 + c0 * 8.;
	r*=pow(md,.5);
	
	gl_FragColor = vec4(vec3(l0, l1, c0), 1.) * r;
}		     		     

float sdfLine(vec2 a, vec2 b){
	float d0,d1,l;
	
	vec2  d = normalize(b - a);
	
	l  = distance(a, b);
	d0 = max(abs(dot(uv - a, vec2(-d.y, d.x))), 0.0),
	d1 = max(abs(dot(uv - a, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float sdfLine(vec3 a, vec3 b){
	float d0,d1,l;
	
	vec3  d = normalize(b - a);
	//this is broken
	l  = length(uvw)/distance(a, b);
	d0 = max(abs(dot(uvw - a, vec3(-d.y, d.x,  d.z))), 0.0),
	d1 = max(abs(dot(uvw - a, -vec3(d.x, d.y, d.z)) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d1, d0));
}

float line(vec2 a, vec2 b, float w){
	float l = sdfLine(a,b);
	return step(l,w);
}

float line(vec3 a, vec3 b, float w){
	float l = sdfLine(a,b);
	return step(l,w);
}

float circle(vec2 p, float r){
	return step(length(uv-p), r);
}



vec4 write(vec4 v, vec2 a){
	vec2 mem = floor(gl_FragCoord.xy);
	vec2 add = floor(a);
	
	if (mem.x == add.x && mem.y == add.y){
		return v;
	}

	return vec4(0.);
}

vec4 read(vec2 a){
	vec2 add = floor(a);
	
	return texture2D(backbuffer, add);
} //sphinx + many others