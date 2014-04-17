// raymarching of http://glsl.heroku.com/e#9722.3
// thank you // sphinx // added light
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float  tri( float x ){
	return (abs(fract(x)-0.5)-0.25);
}
vec3 tri( vec3 p ){
	return vec3( tri(p.x), tri(p.y), tri(p.z) );
}

// public domain
#define N 16
#define PI2 (3.14159265*2.0)


float mx = sin(.32 + time * 0.00037312) * 1.45 + 0.5;
float my = cos(.01 + time * 0.00023312) * 1.45 + 0.5;
//float mx = 24.5 + sin(1.32 * 0.0037312) * 1.45 + 0.5;
//float my = 24.5 + cos(1.01 * 0.0023312) * 1.45 + 0.5;
float c1 = cos(my * PI2);
float s1 = sin(my * PI2);
float c2 = cos(mx * PI2);
float s2 = sin(mx * PI2);
float c3 = cos(mouse.x * PI2);
float s3 = sin(mouse.x * PI2);
//float c3 = cos(.5 * PI2);
//float s3 = sin(.5 * PI2);

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

float dist( vec3 v, out vec3 c) {
	vec3 vsum = vec3(0.0);
	float zoomed = 1.;
	
	for ( int i = 0; i < N; i++ ){
		float f = float(i) / float(N);
		float mul =  1.0 + 0.1/(f*f+0.45);
		v *= mul;
		zoomed *= mul;
		
		v += (mouse.y-.5)*.5+.5;
		
		v *= rotmat;
		v = tri(abs(v-v*2.));
	}
	
	c = v;
	
	return (v.x + .01) / zoomed;
}


#define M 24
void main(){
	vec3 dir = normalize(vec3( (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0, 1.0));
	vec3 pos = vec3(0.0, 0., -1.);
	float t = 1.0;
	
	vec3 c;
	vec3 o;
		
	int j = 0;
	for ( int i = 0; i < M; i++ ){
		
		vec3 p = pos + dir * t;
		
		float d = dist( p, c );
		if ( abs(d) < 0.000001 ){
			
			d = float(M-i) / float(M);			
		
			vec3 c0 = vec3(.85, .58, .35);
			vec3 c1 = vec3(.25, .15, .84);
			
			vec3 c = mix(c0, c1, d);
			
			vec3 lp = vec3(3. + mouse.x, 1. + mouse.y, -3.);
			vec3 lc = vec3(.9, .6, .2);
			
  			const float e = 0.001;
			
			vec3 n = normalize(vec3(
     						dist(p+vec3( e,.0,.0), o)-dist(p+vec3(-e,.0,.0), o),
    						dist(p+vec3(.0, e,.0), o)-dist(p+vec3(.0,-e,.0), o),
      						dist(p+vec3(.0,.0, e), o)-dist(p+vec3(.0,.0,-e), o)
			 			));
			
			vec3 ld = normalize(p+lp);
			float ndl = dot(n, ld);
			
			vec3 h = c * reflect(dir, ld);
			float ndh = dot(n, h);
			
			float a = dot(dir, o);
			
			float s = pow(64., a * ndh) * 0.344;
			
			float f = d * min(1., max(0., 0.2 * (d + length(o))));
			
			gl_FragColor = vec4(f + d * (vec3(ndl*lc) + s), 1.);
			return;
		}
		t += d * 0.99;
	}
	
			
	gl_FragColor = vec4(length(c)*vec3(0.2, 0.25, .37), 1.);

}
