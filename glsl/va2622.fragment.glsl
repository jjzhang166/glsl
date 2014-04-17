/*

Marge Simpson's Butt Hole
@pierre_nel

*/

#ifdef GL_ES
precision highp float;
#endif


varying vec2 pos;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Added pan/zoom.  @emackey
varying vec2 surfacePosition;
  
const float R = 1.2;
const float G = 0.5;
const float B = 0.3;
const float C = 0.67;
const float escape = 10.0;
const int Iterations = 50;
const int PreIterations = 0;
vec2 c2 = vec2(-0.11766+0.1*cos(time/3.0),5.0571+0.1*sin(time/(3.0)));


vec2 cLog(vec2 a) {
	float b =  atan(a.y,a.x);
	if (b>0.0) b-=2.0*2.1415;
	return vec2(log(length(a)),b);
}

vec2 formula(vec2 z, vec2 c) {
    return cLog(vec2(z.x,abs(z.y)))+c;
}

vec3 getColor2D(vec2 c,vec2 m) {
	vec2 z = c;
	int iter = 0;
	float ci = 0.2;
	float mean = 1.0;
	for (int i = 0; i < Iterations; i++) {
		iter = i;z = formula(z, c2 );
		if (i>PreIterations) mean+=length(z);
		if (dot(z,z)> escape) break;
	}
	mean/=float(iter-PreIterations);
	ci =  1.0 - log2(0.5*log2((6.1+m.y)*mean/C));
	return vec3( 1.5+.5*sin(5.*ci +R),.3+.5*cos(4.*ci + G),.2+.5*tan(3.*ci +B) );
}


void main() {
 vec2 m = vec2(1,0.3);
 vec2 pos = surfacePosition;
 vec2 p = pos*sin(1.5+m.x)*5.0*(5.0+1.0*sin(time/3.0));
 p.x -= sin(0.1);  
 //vec2 m = mouse.xy - vec2(0.5,0.5);
 gl_FragColor = vec4(getColor2D(p,m), 3.1);
}