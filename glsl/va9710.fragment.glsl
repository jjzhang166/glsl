#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float  tri( float x, float l ){
	return (abs(fract(x/l*1.06)-0.5)-0.25)*l;
}
vec3 tri( vec3 p, float l ){
	return vec3( tri(p.x,l), tri(p.y,l), tri(p.z,l) );
}

// public domain
#define N 20
#define PI2 (3.14159265*2.0)
void main( void ) {
	vec3 v = vec3( (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 0.5, 0.0);
	v.z = time*.01;
	
	float mx = sin(1.32 + time * 0.0037312) * 1.45 + 0.5;
	float my = cos(1.01 + time * 0.0023312) * 1.45 + 0.5;
	
	float c1 = cos(my * PI2);
	float s1 = sin(my * PI2);
	float c2 = cos(mx * PI2);
	float s2 = sin(mx * PI2);

	for ( int i = 0; i < N; i++ ){
		v = vec3( v.x*c1-v.y*s1, v.y*c1+v.x*s1, v.z ); // rotate
		v = vec3( v.x, v.y*c2-v.z*s2, v.z*c2+v.y*s2 ); // rotate
		v = tri( v, 1.0/float(i+3) ); // fold
	}
	
	gl_FragColor = vec4( cos(v*float(N*30) * 0.3), 1.0 );

}