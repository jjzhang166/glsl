#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 4.*atan(1.); //better pi, not constant

float sdf(vec2 p, vec2 uv){
	return length(uv-p);
}

float lsdf(vec2 a, vec2 b, vec2 uv){
	float d0,d1,l;
	
	vec2  d = normalize(b.xy - a.xy);
	
	l  = distance(a.xy, b.xy);
	d0 = max(abs(dot(uv - a.xy, d.yx * vec2(-1.0, 1.0))), 0.0),
	d1 = max(abs(dot(uv - a.xy, d) - l * 0.5) - l * 0.5, 0.0);
	
	return length(vec2(d0, d1));
}

float wave(vec2 p, vec4 w){
	p.y /= w.x;
	return abs(sin(time*w.z-p.x*pi*w.y)-p.y);
}

float circle(vec2 p, vec2 uv, float r){
	return step(sdf(p,uv), r);
}

float line(vec2 a, vec2 b, vec2 uv, float w){
	float l = lsdf(a,b,uv);
	return step(l,w);
}

vec4 clamp(vec4 v){
	return min(vec4(1.), max(vec4(0.), v));
}

void main( void )
{
	vec2 uv = 8. * (gl_FragCoord.xy) / resolution.xx;
	
	vec2 p = uv;
	
	vec2 a0, a1, a2, b0, b1, b2;
	a0 = 5.*vec2(1., .5);
	b0 = a0 - vec2(sin(time), cos(time));
	a1 = b0;
	b1 = a1 - .5*vec2(sin(time*2.), cos(time*2.));
	a2 = a0;
	b2 = b1;
	
	
	float s  = sdf(a0, uv);
	float s0 = sdf(b0, b0 * uv);
	float s1 = sdf(b1, b1 * uv);
	float s2 = sdf(b2, b2 * uv);
	
	float l0 = line(a0, b0, uv, 0.02);
	float l1 = line(a1, b1, uv, 0.02);
	float l2 = line(a2, b2, uv, 0.02);
	
	
	float lf0 = lsdf(a0, b0, uv);
	float lf1 = lsdf(a1, b1, uv);
	float lf2 = lsdf(a2, b2, uv);
	
	
	gl_FragColor = vec4(lf0+lf1+lf2)*.5 + vec4(lf0,lf1,lf2, 1.) +  + vec4(l0,l1,l2, 1.);
}