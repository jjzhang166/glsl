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

	/**/
	for(float i=0.0; i<8.0;i++){
		nd =cos(3.14159*i*pos.x + (i*2.75+cos(+time)*0.24) + time)*(pos.x+0.3)+0.5;
		amnt = 1.0/abs(nd-pos.y)*0.005; 
		
		cbuff += vec4(amnt, amnt*0.2 , amnt*pos.y, 2.0);
	}
	
	vec4 dbuff =  texture2D(backbuffer,1.0-pos)*0.1;
  	gl_FragColor = cbuff + dbuff;
}
