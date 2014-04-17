//MG - Lens
#ifdef GL_ES
precision mediump float;
#endif
#define RAD	0.2

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 warp_effect();

void main( void ) {
	vec2 p=(gl_FragCoord.xy/resolution.y);
	p.x-=resolution.x/resolution.y/2.0;p.y-=0.5;
	vec2 c1=warp_effect();
	p.xy+=c1.xy;
	
	gl_FragColor=vec4(0.002/mod(p.x,0.04),0.001/mod(p.x,0.04),0.001/mod(p.x,0.04),0.0);
	gl_FragColor+=vec4(0.002/mod(-p.x,0.04),0.001/mod(-p.x,0.04),0.001/mod(-p.x,0.04),0.0);
	
	gl_FragColor+=vec4(0.002/mod(p.y,0.04),0.001/mod(p.y,0.04),0.001/mod(p.y,0.04),0.0);
	gl_FragColor+=vec4(0.002/mod(-p.y,0.04),0.001/mod(-p.y,0.04),0.001/mod(-p.y,0.04),0.0);
}

vec2 warp_effect() {
	vec2 w=(gl_FragCoord.xy/resolution.y);
	w.x-=resolution.x/resolution.y/2.0;w.y-=0.5;
	vec2 dudv;
	
	w.y-=mouse.y-0.5;
	w.x-=(mouse.x-0.5)*resolution.x/resolution.y;
	if (sqrt(w.x*w.x+w.y*w.y)<RAD-RAD*0.04) {
		dudv.x=(-w.x/sqrt(RAD*RAD-w.x*w.x-w.y*w.y));
		dudv.y=(-w.y/sqrt(RAD*RAD-w.x*w.x-w.y*w.y));
		return dudv/40.0;
	}
	else {
		return vec2(0.0,0.0);	
	}
	
}