// raymarching of http://glsl.heroku.com/e#9722.3
// is this the kali set? //sphinx

// maybe variation of kaliset // anonymous
// kaliset = inverse + shift + fold
// this fractal = rotate + zoom + shift + fold
// the essence is folding operator.  http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/msg31892/#msg31892

//thx anon - maybe it wants some quazicrystal now
	
	
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float  tri( float x ){
	return (abs((x)-0.5)-0.25);
}
vec3 tri( vec3 p ){
	return vec3( tri(p.x), tri(p.y), tri(p.z) );
}

// public domain

#define PI 4./atan(1.)
#define PI2 2.*PI
#define R 6.0
#define RM 7.0
#define G 6.0
#define GM 7.0
#define B 6.0
#define BM 7.0

vec3 quazicrystal( vec3 position ) {
	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;

	for (float i = 0.0; i < R; ++i) {
		float a = i * (2.0 * PI / RM);
		r += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 4.0 + 0.5;
	}
	float m = mod(r, 2.0);
	if (m >= 1.0) r = 2.0 - m;
	else r = m;
	
	for (float i = 0.0; i < G; ++i) {
		float a = i * (2.0 * PI / GM);
		g += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 4.0 + 0.5;
	}
	m = mod(g, 2.0);
	if (m >= 1.0) g = 2.0 - m;
	else g = m;
	
	for (float i = 0.0; i < B; ++i) {
		float a = i * (2.0 * PI / BM);
		b += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 3.0 + 0.5;
	}
	m = mod(b, 2.0);
	if (m >= 1.0) b = 2.0 - m;
	else b = m;

	return vec3(r,g,b);

}

float mx = sin(mouse.y* PI2);
float my = cos(mouse.y * PI2);
float c1 = cos(my * PI2);
float s1 = sin(my * PI2);
float c2 = cos(mx * PI2);
float s2 = sin(mx * PI2);
float c3 = cos(mouse.x * PI2);
float s3 = sin(mouse.x * PI2);

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

#define N 16
vec3 dist( vec3 v ) {
	vec3 vsum = vec3(0.);
	float zoomed = 1.;
	vec3 p = v;
	for ( int i = 0; i < N; i++ ){
		float f = float(i) / float(N);
		float mul =  1.1 + f;
		v *= abs(mul);
		zoomed *= mul;
			
		v -= quazicrystal(4.*v)*.1;
		v *= rotmat;
		v = tri( v ); // fold // -0.25 <= tri() <= +0.25
	}

	return v/zoomed;
}


#define M 24
void main(){
	vec3 dir = normalize(vec3( (gl_FragCoord.xy - resolution*.5) / min(resolution.y,resolution.x) * 2., -1.));
	vec3 pos = vec3(0., 0., 6.);
	float t = 0.;
	
	int j = 0;
	for ( int i = 0; i < M; i++ ){
		vec3 ray = dist( pos + dir * t );
		float d = length(ray);
		if ( i == 0 && d < 0.0 )
			dir = -dir;
		
		if ( abs(d) < 0.005 ){
			float c = float(M-i) / float(M);
			vec3 q = quazicrystal(ray*dir);
			gl_FragColor = vec4(c*q,0.);
			return;
		}
		t += d * 1.00;
	}
	
	gl_FragColor = vec4( 0.0, 0.0, abs(0.2/t), 1.0 );

}
