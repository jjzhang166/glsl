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
	p.x+=sin(p.x*1.0+time);
	p.y+=sin(p.x*1.0+time);
	return p;
}

void main() {
	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;pos.y-=0.5;
	pos=sincostime(pos) / 6.0;
	vec2 mse;
	mse.x+=(mouse.x-0.5)*resolution.x/resolution.y;mse.y+=mouse.y-0.5;
	vec4 c = vec4(0.0);
	float fx=sin(pos.x*10.0+time*GRE_SPEED+mse.x*GRE_SPEED*2.0)/3.0;
	float dist=abs(pos.y-fx)*50.0;
	c+=vec4(0.5/dist,1.0/dist,0.5/dist,1.0);
	
	fx=cos(pos.x*20.0+time*RED_SPEED+mse.x*RED_SPEED*2.0)/4.0;
	dist=abs(pos.y-fx)*50.0;
	c+=vec4(1.0/dist,0.5/dist,0.5/dist,1.0);
	
	fx=cos(pos.x*5.0+time*BLU_SPEED+mse.x*BLU_SPEED*2.0)/2.0;
	dist=abs(pos.y-fx)*5.0;
	c+=vec4(0.5/dist,0.5/dist,1.0/dist,1.0);
	gl_FragColor = c;
}