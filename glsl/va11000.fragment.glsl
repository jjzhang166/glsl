#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 pos =gl_FragCoord.xy / resolution;
	float amnt = 0.5;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	/*
	for(float i=0.0; i<2.0;i++){
		nd =cos(3.14*2.1*pos.x + (i*0.98+cos(+time)*0.3) + time)*0.79+0.25 + pos.x;
		amnt = 1.0/abs(nd-pos.y)*0.25; 
		
		cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y, 1.0);
	}
	*/	

	for(float i=0.0; i<8.0;i++){
		nd =sin(3.14*i*pos.y + i*800.0 + time)*0.24*(pos.y+0.3)+0.5;
		amnt = 1.0/abs(nd-pos.x)*0.0075;
		
		cbuff += vec4(amnt*0.9, amnt*0.1 , amnt*pos.x, 1.0);
	}
	
	vec4 dbuff =  texture2D(backbuffer,1.0-pos)*0.;
  	gl_FragColor = cbuff + dbuff;
}
