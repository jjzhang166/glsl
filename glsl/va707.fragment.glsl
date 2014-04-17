//for slow HW

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	gl_FragColor.r = mod(floor(mod(pos.x*82464578679.,mouse.x*3581.)+.5)*(mod(mouse.x*46781.,mouse.y*1.)+.5),2.0);//mod(time*mouse.x,(pos.y)/(pos.x*1.00001));//mod(time*170./pos.x,pos.x*4.2-pos.y*2.5);
	gl_FragColor.g = (1.-mod(pos.x*84985675865465365565.,mouse.y*1428.*pos.y*394448.+mouse.x*366944665698746.)/488524563937.);//resolution.x/2000.; //mod(time*1000.,mouse.x/pos.y*1./pos.x*1.);//mod(time*1000./pos.y,-pos.y+pos.x*5.);
	gl_FragColor.b = (floor(mod(mouse.y*89601.,pos.x*4.)+.5)-mod(pos.x*4.,mouse.y)/4.);//mod(time*1000.00003,pos.y/(pos.x*2.00001*mouse.y));//mod(time*711.1/pos.x,3.5-pos.y*4.-pos.x*1.5);;
  	gl_FragColor.a = 0.;

}