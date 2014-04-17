//MG
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float noise(vec2);
float fbm(vec2);
float smooth(vec2,float);
float cos_int(float,float,float);
void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*10.0;
	p.x-=resolution.x/resolution.y*5.0;p.y-=5.0;
	vec2 q=gl_FragCoord.xy/resolution.xy;
	vec2 mse=mouse*10.0;
	mse.x=(mse.x-5.0)*resolution.x/resolution.y;mse.y-=5.0;
	float dist,fx;
	
	vec4 col=texture2D(backbuffer,vec2(q.x,q.y));
	gl_FragColor+=col*0.90;
	
	dist=0.02/sqrt((p.x-mse.x)*(p.x-mse.x)+(p.y-mse.y)*(p.y-mse.y));
	gl_FragColor+=vec4(4.0*dist,2.0*dist,1.0*dist,1.0);
	gl_FragColor+=vec4(0.0,0.0,fbm(p+mse)*0.1,1.0);
}

float fbm(vec2 p) {
	float ret=0.0;
	
	ret+=1.000*smooth(p,1.0);
	ret+=0.500*smooth(p,2.0);
	ret+=0.250*smooth(p,4.5);
	ret+=0.125*smooth(p,8.0);
	
	return ret/1.825;
}

float smooth(vec2 p,float f) {
	p*=f;
	float a=cos_int(noise(p),noise(vec2(p.x,p.y+1.0)),p.y);
	float b=cos_int(noise(vec2(p.x+1.0,p.y)),noise(vec2(p.x+1.0,p.y+1.0)),p.y);
	return cos_int(a,b,p.x);
}

float cos_int(float a,float b,float x) {
	float ft=fract(x)*3.1415927;
	float f=(1.0-cos(ft))*0.5;	
	return a*(1.0-f)+b*f;
}

float noise(vec2 p) {
	p=floor(p);
	return abs(fract(sin(p.x*45.11+p.y*97.23)*878.73+733.17)*2.0-1.0);
}