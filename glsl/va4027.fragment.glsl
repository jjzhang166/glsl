// sun n stars by zed
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



void main(void) {
	vec4 blk=vec4(0.0, 0.0, 0.0, 0.0);
	vec4 sun=vec4(1.0, 1.0, 0.0, 1.0);
	vec4 star=vec4(1.0, 1.0, 1.0, 1.0);
	
    vec2 p = ( gl_FragCoord.xy/ resolution.y ); // normalize y-axis

	p -= vec2(mouse.x*1.45,mouse.y+0.0); //BUG
//	p -= vec2((resolution.x/resolution.y)/2.0, 0.5); // center origin

	float l=length(p)*1.0;
	
	if(l<0.5*1.0) {
		l=l*200.0;
		l=mod(l-time*2.0,1.0);///2.0;
		if(l<0.5) {l=l*2.0;} else { l=(1.0-l)*2.0;} //sawtooth
		gl_FragColor = mix(sun,star,l);
		//if(l>0.5) gl_FragColor=fg;
	}
	else {
		l=l*2000000.0;
		l=mod(l-time*1.0,15.0);	
		if(l<0.5) gl_FragColor=star;
	}
	
}
