//MG
#ifdef GL_ES
precision mediump float;
#endif
#define BLU_SPEED	0.5
#define RED_SPEED	0.9
#define GRE_SPEED	0.2

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 sincostime( vec2 p ){
	p.x+=sin(p.x*2.0+time)*0.4-cos(p.y*1.0-time)*0.5-sin(p.x*3.0+time)*0.3+cos(p.y*3.0-time)*0.1;
	p.y+=sin(p.x*5.0+time)*0.7+cos(p.y*8.0-time)*0.3+sin(p.x*4.0+time)*0.5-cos(p.y*6.0-time)*0.3;
	return p;
}

void main() {
	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;pos.y-=0.5;
	pos=sincostime(pos) / 6.0;
	vec2 mse;
	mse.x+=(mouse.x-0.5)*resolution.x/resolution.y;mse.y+=mouse.y-0.5;
	
	float fx=sin(pos.x*10.0+time*GRE_SPEED+mse.x*GRE_SPEED*2.0)/3.0;
	float dist=abs(pos.y-fx)*50.0;
	gl_FragColor+=vec4(0.5/dist,1.0/dist,0.5/dist,1.0);
	
	fx=cos(pos.x*20.0+time*RED_SPEED+mse.x*RED_SPEED*2.0)/4.0;
	dist=abs(pos.y-fx)*50.0;
	gl_FragColor+=vec4(1.0/dist,0.5/dist,0.5/dist,1.0);
	
	fx=cos(pos.x*5.0+time*BLU_SPEED+mse.x*BLU_SPEED*2.0)/2.0;
	dist=abs(pos.y-fx)*50.0;
	gl_FragColor+=vec4(0.5/dist,0.5/dist,1.0/dist,1.0);
}