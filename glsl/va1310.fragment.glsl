#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// An attempt at Quilez's warping (domain distortions):
// http://iquilezles.org/www/articles/warp/warp.htm
// 
// Not as good as his, but still interesting.
// @SyntopiaDK, 2012

// Note for this fork: This really reminds me of Half-Life 2: Episode 2s HDR so I forked it



float rand(vec2 co){
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise2f( in vec2 p )
{
	vec2 ip = vec2(floor(p));
	vec2 u = fract(p);
	// http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
	u = u*u*(3.0-2.0*u);
	//u = u*u*u*((6.0*u-15.0)*u+10.0);
	
	float res = mix(
		mix(rand(ip),  rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),   rand(ip+vec2(1.0,1.0)),u.x),
		u.y)
	;
	return res*res;
	//return 2.0* (res-0.5);
}

float fbm(vec2 c) {
	float f = 0.0;
	float w = 1.0;
	for (int i = 0; i < 2; i++) {
		f+= w*noise2f(c);
		c*1.0;
		w*= 0.5;
	}
	return f;
}



vec2 cMul(vec2 a, vec2 b) {
	return vec2( a.x*b.x -  a.y*b.y,a.x*b.y + a.y * b.x);
}

float pattern(  vec2 p, float time)
{
	vec2 q,r; 
	q.x = fbm( p + .00*time);
	q.y = fbm( p + vec2(1.0));
	
	r.x = fbm( p +1.0*q + vec2(1.7,9.2)+0.15*time );
	r.y = fbm( p+ 1.0*q + vec2(8.3,2.8)+0.126*time);
	//r = cMul(q,q+0.1*time);
	return fbm(p +1.0*r + 0.0* time);
}

//----
float f(float x) {
	return (sin(x * 2.0 * PI ) + 1.0) / 2.0;
}

float q(vec2 p) {
	float s = (f(p.x + 0.25)) / 5.0; 
	
	float c = smoothstep(0.9, 1.0, 1.0 - abs(p.y - s));  
	return c; 
}

vec3 aurora(vec2 p, float time) {
	vec3 c1 = q( vec2(p.x, p.y / 0.4) + vec2(0.0, -0.5)) * vec3(1.0, 1.0, 1.0); 	
	vec3 c2 = q( vec2(p.x, p.y) + vec2(time, -0.2)) * vec3(.1, .1, 1.0); 	
	vec3 c3 = q( vec2(p.x*2.0, p.y / 0.4) + vec2(time / 2.0, -0.5)) * vec3(.10, 1.0, .10); 
	
	return c1+c2+c3; 
}
//---

void main() {
	vec2 c = 1000.0*gl_FragCoord.xy/ resolution.xy;
	float f = pattern(c*.01, time);	
	vec3 col = aurora(f*c / 1000.0, time);
	
	gl_FragColor =  vec4(col,1.0);
}

