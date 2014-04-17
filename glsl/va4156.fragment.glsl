//MG
#ifdef GL_ES
precision mediump float;
#endif
#define BLU_SPEED	0.4
#define RED_SPEED	0.8

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;pos.y-=0.5;
	vec2 mse;
	mse.x+=(mouse.x-0.5)*resolution.x/resolution.y;mse.y+=mouse.y-0.5;
	
	float fx=sin(pos.x*10.0+time*BLU_SPEED+mse.x*BLU_SPEED*2.0)/4.0;
	float dist=abs(pos.y-fx)*80.0;
	gl_FragColor+=vec4(0.5/dist,0.5/dist,1.0/dist,1.0);
	
	fx=cos(pos.x*10.0+time*RED_SPEED+mse.x*RED_SPEED*2.0)/4.0;
	dist=abs(pos.y-fx)*80.0;
	gl_FragColor+=vec4(1.0/dist,0.5/dist,0.5/dist,1.0);
	
	if (pos.y<=-0.2) {
		gl_FragColor+=vec4(abs(pos.y+0.2),abs(pos.y+0.2),abs(pos.y+0.2),1.0);
	}
}