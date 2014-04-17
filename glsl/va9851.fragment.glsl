#ifdef GL_ES
precision mediump float;
#endif

//messing around
//public domain

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
varying vec2 surfacePosition;

#define sp surfacePosition

#define suv (gl_FragCoord.xy / resolution.xy)
#define m mouse
#define md length(uv-m)

#define origin vec2(0.)
#define center vec2(.5)

#define PI  4.*atan(1.) 
#define TAU 2.*PI


//vars
vec2 uv;

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


//functions
float circle(vec2 p, float r);
float sdfLine(vec2 a, vec2 b);
float line(vec2 a, vec2 b, float w);
vec4 write(vec4 v, vec2 a);
vec4 read(vec2 a);
vec4 read_uv(vec2 a);
vec2 samplePattern(float d);
vec4 sample(vec2 p);
vec2 subTexture(vec2 p, float s);
float mask(vec2 p, vec2 s);

vec4 result = vec4(0.);

void main( void ) {	
	uv = suv;
	
	//MainTex
	float mainTex = mask(vec2(.12, .25), vec2(2., 2.));
	uv = subTexture(vec2(.12, .25), 2.);
	result += mainTex-vec4(line(vec2(.5),  m + vec2(.25), 0.01));
	
	//Replica Test - this is eventually supposed to be a backbuffer copy...
	uv = subTexture(vec2(.75, .0), 4.);
	result	+= vec4(line(vec2(.5),  m + vec2(.25), 0.01));

	vec4 buffer = read(gl_FragCoord.xy);	
//	if(mainTex == 1. && buffer == result){
//		//TexData
//		uv = subTexture(vec2(.75, .75), 4.);	
//		result += vec4(samplePattern(1.),0.,1.);
//	}
	
	gl_FragColor = result + buffer;
}		     		     

vec2 subTexture(vec2 p, float s){
	uv = suv;
	vec2 t = uv*s-p*s;
	vec2 uv = fract(t);
				 
	float m = mask(p, vec2(s, s));			 
	
	p = uv*m;
	
	uv = suv;
	return p;
}

float mask(vec2 p, vec2 s){
	vec2 t = uv*s-p*s;
				 
	float m = 0.;			 
	
	if ((t.x > 0. && t.y > 0.) && (t.x < 1. && t.y < 1.) ){
		m = 1.;
	}
	
	return m;
}

vec2 samplePattern(float d){
	
	vec2 l0 = vec2(fract(uv*d));
	vec2 l1 = floor(l0*d)/d;
	
	vec2 r = l1;
	
	return vec2(r);
}

vec4 sample(vec2 p){
	
	return vec4(1.);
}

float sdfLine(vec2 a, vec2 b){
	float d0,d1,l;
	
	vec2  d = normalize(b - a);
	
	l  = distance(a, b);
	d0 = max(abs(dot(uv - a, vec2(-d.y, d.x))), 0.0),
	d1 = max(abs(dot(uv - a, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float line(vec2 a, vec2 b, float w){
	float l = sdfLine(a,b);
	return step(l,w);
}

float circle(vec2 p, float r){
	return step(length(uv-p), r);
}

vec4 write(vec4 v, vec2 a){
	vec2 mem = floor(gl_FragCoord.xy);
	vec2 address = floor(a);
	
	if (mem.x == address.x && mem.y == address.y){
		return vec4(1.);
	}

	return vec4(0.);
}


//seems broken =(
vec4 read(vec2 a){
	vec2 address = floor(a);
	
	return texture2D(backbuffer, address);
}

vec4 read_uv(vec2 a){
	return read(uv*resolution);
} 

//sphinx