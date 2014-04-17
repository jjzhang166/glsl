#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.1415926;

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
	return smoothstep(.02, 0., wave(p, w));
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
void Signal(vec2 p, out float signal, out vec4 components){
	float a = 1.; //amplitude
	float w = 1.; //wavelength
	float f = 1.; //frequency
	float c	= 1.; //phase
	
	vec4 s0 = vec4(a*2.2, w     , f     ,  c); 
	vec4 s1 = vec4(a, w * 2., f * .3,  c); 
	vec4 s2 = vec4(a*.4, w * 5., f * 7.,  c); 
	vec4 s3 = vec4(a*1.5, w * 7., f * 2.,  c); 
	
	components.x = waveLine(p, s0);
	components.y = waveLine(p, s1);
	components.z = waveLine(p, s2);
	components.w = waveLine(p, s3);
	
	p.y += wave(p, s0);
	p.y += wave(p, s1);
	p.y += wave(p, s2);
	p.y += wave(p, s3);
	
	signal = step(pi*pi, p.y*1.05) - step(pi*pi, p.y) ;
}

//Background
void Background(out vec4 bg){
		
	float g = grid(pi*10.) * .25;
	
	vec4 bgC = vec4(.2,.2,.2, 1.);
	
	bg = clamp(bgC+vec4(g));
}
	


void main( void )
{
	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * pi * 2.;
	vec2 p = uv-pi;
	
	//Background
	vec4 bg;
	Background(bg);
	
	//Signal Waves
	float signal;
	vec4 components;
	Signal(p, signal, components);
			
	
	gl_FragColor = bg + clamp((signal*32.) + components);
}