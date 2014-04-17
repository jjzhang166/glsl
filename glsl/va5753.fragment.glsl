#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592653589793238462643383279502884197;

float rand(vec2 co){
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 434658.5453116487577816842168767168087910388737310);
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
	for (int i = 0; i < 8; i++) {
		f+= w*noise2f(c);
		c*=2.0;
		w*=0.5;
	}
	return f;
}

float ft() {
	float t = time + 6000.0;
	t = (1.0/ t ) * 10000.0;
	return t;
}


float pattern(  vec2 p, out vec2 q, out vec2 r ) {
	q.x = fbm( p  +0.00*time);
	q.y = fbm( p + vec2(1.0));
	
	r.x = fbm( p +1.0*q + vec2(1.7,9.2)+0.15*time );
	r.y = fbm( p+ 1.0*q + vec2(8.3,2.8)+0.126*time);
	return fbm(p +1.0*r + 0.00000* time);
}


const vec4 blue = vec4(0.0, 0.0, 1.0, 0.0);
const vec4 green = vec4(0.0, 1.0, 0.0, 0.0);
void main( void ) {
        vec2 ref = vec2(1.0, 0.0);
	
	vec2 dir = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	float dist = distance( gl_FragCoord.xy / resolution.xy, vec2(0.5, 0.5 ));
	dist = log(log(dist));
	vec2 q,r;
	float f = pattern(vec2((dist + 0.5*time) *ft() , acos(dot(dir, ref))), q, r);
	vec4 color = mix (blue * 0.5, vec4(0.6, 0.8, 1.0, 0.0), clamp(f * f * 1.0, 0.0, 1.0));
	color.y += mix(color, green, q.y);
	gl_FragColor = color;
}
