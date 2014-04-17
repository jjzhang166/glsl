//MG
#ifdef GL_ES
precision mediump float;
#endif
#define RED 	0.0
#define GRN 	0.4	//Distance of Green circles from center.
#define BLU 	0.8	//Distance of blue circles from center.
#define WIDTH	0.05	//Width of lines.  0.0 ~ 0.2

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos=(gl_FragCoord.xy/resolution.y);
	pos.x-=resolution.x/resolution.y/2.0;
	pos.y-=0.5;
	
	float dist=sqrt((pos.x-0.0)*(pos.x+BLU)+(pos.y-0.0)*(pos.y+0.0));
	if (mod(dist-time/10.0,0.2)<WIDTH) {
		gl_FragColor+=vec4(0.0,0.0,1.0,1.0);
	}
	
	dist=sqrt((pos.x-BLU)*(pos.x+0.0)+(pos.y-0.0)*(pos.y+0.0));
	if (mod(dist-time/10.0,0.2)<WIDTH) {
		gl_FragColor+=vec4(0.0,0.0,1.0,1.0);
	}
	
	dist=sqrt((pos.x-0.0)*(pos.x+GRN)+(pos.y-0.0)*(pos.y+0.0));
	if (mod(dist-time/10.0,0.2)<WIDTH) {
		gl_FragColor+=vec4(0.0,1.0,0.0,1.0);
	}
	
	dist=sqrt((pos.x-GRN)*(pos.x+0.0)+(pos.y-0.0)*(pos.y+0.0));
	if (mod(dist-time/10.0,0.2)<WIDTH) {
		gl_FragColor+=vec4(0.0,1.0,0.0,1.0);
	}
	
	dist=sqrt((pos.x-0.0)*(pos.x+0.0)+(pos.y-0.0)*(pos.y+0.0));
	if (mod(dist-time/10.0,0.2)<WIDTH) {
		gl_FragColor+=vec4(1.0,0.0,0.0,1.0);
	}
}