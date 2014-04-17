// raymarching of http://glsl.heroku.com/e#9722.3
// is this the kali set? //sphinx

// maybe variation of kaliset // anonymous
// kaliset = inverse + shift + fold
// this fractal = rotate + zoom + shift + fold
// the essence is folding operator.  http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/msg31892/#msg31892

	
	
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
#define N 24
#define PI 4./atan(1.)
#define PI2 2.*PI

float mx = sin(mouse.x * PI2)+sin(time*.00015);
float my = cos(mouse.x * PI2)-cos(time*.00031);
float c1 = cos(my * PI2);
float s1 = sin(my * PI2);
float c2 = cos(mx * PI2);
float s2 = sin(mx * PI2);
float c3 = cos(mouse.y * PI2);
float s3 = sin(mouse.y * PI2);

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

float dist( vec3 v ) {
	vec3 vsum = vec3(0.);
	float zoomed = 1.;
	vec3 p = v;
	for ( int i = 0; i < N; i++ ){
		float f = float(i) / float(N);
		float mul =  1.1 + f*.5;
		v *= abs(mul);
		zoomed *= mul;
			
		v *= rotmat;
		v = tri( v ); // fold // -0.25 <= tri() <= +0.25
	}
	
	float t = length(v/zoomed)-.01;
	
	return t;
}


#define M 48
void main(){
	vec3 dir = normalize(vec3( (gl_FragCoord.xy - resolution*.5) / min(resolution.y,resolution.x) * 2., -1.));
	vec3 pos = vec3(0., 0., 6. + cos(time*.5) * 3.);
	float t = 0.;
	
	int j = 0;
	for ( int i = 0; i < M; i++ ){
		float d = dist( pos + dir * t );
		if ( i == 0 && d < 0.0 )
			dir = -dir;
		
		if ( abs(d) < 0.0005 ){
			float c = float(M-i) / float(M);
			gl_FragColor = vec4( c*.9, c*.85, c*c*.9+abs(0.0007/t) , 1.0 );
			return;
		}
		t += d * 1.00;
	}
	
	gl_FragColor = vec4( 0.0, 0.0, abs(0.2/t), 1.0 );

}
