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

float waveLine(vec2 p, vec4 w){
	return smoothstep(.05, 0., wave(p, w));
}

float grid(float div){
	float x = floor(mod(gl_FragCoord.x, div));
	float y = floor(mod(gl_FragCoord.y, div));
	return 1. - min(x,y);
}

vec4 clamp(vec4 v){
	return min(vec4(1.), max(vec4(0.), v));
}

//Signal Waves
void Signal(vec2 p, out float signal, out vec4 components, out vec4 componentDisp){
	float a = 1.; //amplitude
	float w = 1.; //wavelength
	float f = 1.; //frequency
	float c	= 1.; //phase
	
	vec4 s0 = vec4(a*2.2, w     , f     ,  c); 
	vec4 s1 = vec4(a, w * 2., f * .3,  c); 
	vec4 s2 = vec4(a*.4, w * 5., f * 7.,  c); 
	vec4 s3 = vec4(a*1.2, w * 7., f * 2.,  c); 
		
	componentDisp.x = waveLine(p, s0);
	componentDisp.y = waveLine(p, s1);
	componentDisp.z = waveLine(p, s2);
	componentDisp.w = waveLine(p, s3);
	
	components.r = wave(p, s0);
	components.g = wave(p, s1);
	components.b = wave(p, s2);
	components.a = wave(p, s3);
	
	p.y += wave(p, s0);
	p.y += wave(p, s1);
	p.y += wave(p, s2);
	p.y += wave(p, s3);
	
	signal = step(pi*pi, p.y*1.05) - step(pi*pi, p.y) ;
}

//Background
void Background(out vec4 bg){
		
	float g = (grid(pi*20.)) * .01;
	
	vec4 bgC = vec4(.01,.01,.01, 01.);
	
	bg = clamp(bgC+vec4(g));
}
	


void main( void )
{
	vec2 uv = 10. * (gl_FragCoord.xy) / resolution.xx;
	
	vec2 p = uv;

	
	vec2 a0, a1, a2, b0, b1, b2;
	a0 = 5.*vec2(1., .5);
	b0 = a0 - vec2(sin(time), cos(time));
	a1 = b0;
	b1 = a1 - .5*vec2(sin(time*2.), cos(time*2.));
	a2 = a0;
	b2 = b1;
	
	float l0 = line(a0, b0, uv, .02);
	float l1 = line(a1, b1, uv, .02);
	float l2 = line(a2, b2, uv, .02);

	
	
	gl_FragColor = vec4(l0+l1+l2)*.5 + vec4(l0,l1,l2, 1.);
}