// raymarching of http://glsl.heroku.com/e#9722.3

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// public domain
#define PI2 (3.14159265*2.0)

float mx = 24.5 + sin(1.32 * .5 * 0.0037312) * 1.45 + 0.5;
float my = 24.5 + cos(1.01 * .5 * 0.0023312) * 1.45 + 0.5;
//float mx = 24.5 + sin(1.32 * mouse.x * 0.0037312) * 1.45 + 0.5;
//float my = 24.5 + cos(1.01 * mouse.y * 0.0023312) * 1.45 + 0.5;
float c1 = cos(my * PI2);
float s1 = sin(my * PI2);
float c2 = cos(mx * PI2);
float s2 = sin(mx * PI2);
float c3 = cos(.08 * PI2);
float s3 = sin(.59 * PI2);
//float c3 = cos(mouse.x * PI2);
//float s3 = sin(mouse.x * PI2);


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


// 3d morton code for 8-bits each
// no overflow check
int mortonEncode(vec3 p) 
{
	// no bitwise in webgl, urgh...
	// somebody optimize this please :)
    	int c = 0;
    	for (int i= 8; i>=0; i--) {
		float e = pow(2.0, float(i));
        	if (p.x/e >= 1.0) {
            		p.x -= e;
            		c += int(pow(2., 2.0*float(i)));
        	}
	    	if (p.y/e >= 1.0) {
            		p.y -= e;
            		c += int(pow(2., 1.0+2.0*float(i)));
		}
		if (p.z/e >= 1.0) {
            		p.z -= e;
            		c += int(pow(2., 2.0+2.0*float(i)));
		}
        }
    	return c;
}

vec3 mortonOrder( vec3 pos ) 
{
	int a = mortonEncode(pos.xyz);
	
	float dist = float(a);
	vec3 c[3];
	c[0] = vec3(1.0, 0.0, 1.0);
 	c[1] = vec3(1.0, 1.0, 0.0);
 	c[2] = vec3(1.0, 0.0, 0.0);
	
	int i = (dist < 0.5)? 0:1;
	vec3 th;
 	th = (i==0) ? mix(c[0], c[1], (dist-float(i) * 0.5) / 0.5) : mix(c[1], c[2], (dist-float(i) * 0.5) / 0.5);
	
	return vec3(32.0*th);
}

vec3 dist( vec3 v ) {
	
	float zoomed = 1.+cos(time * .25) * .365;
	v *= rotmat;
	v += mortonOrder(v);
	
	return floor(v)/zoomed;
}


#define M 64
void main(){
	vec3 dir = normalize(vec3( (gl_FragCoord.xy - resolution.xx/2.0) / min(resolution.x,resolution.y) * 2.0, 1.0));
	vec3 pos = vec3(0., 0., -0.);
	
	float t = 32.0;
	
	int j = 0;
	for ( int i = 0; i < M; i++ ){
		vec3 d = dist( pos + dir * t );
		if ( length(d) > 262144.0 ){
			gl_FragColor = vec4( float(M-i) / float(M) ) * vec4(-dir.xy, .5 * dir.z, 1.) * (1.+ cos(.0001*length(d))*.45);
			return;
		}
		t += d * .01;
	}
	
	gl_FragColor = vec4( 0.0 );
} //sphinx + florian + mysterious benefactors