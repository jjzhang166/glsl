#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 1.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<15.0;i++){
	
	nd = sin(3.03*-0.3*pos.x + (i* 90.1+sin(time)*0.4) + time)*0.4+0.1 + pos.y * 0.001;
	amnt = 1.0/abs(nd-pos.y)*0.01; 
	
	cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y, 1.0);
	}
	
	for(float i=0.0; i<1.0;i++){
	nd = cos(3.0*pos.y + i*0.07 + time)*50.3*(pos.y + 85.0)+0.5;
	amnt = 1.0/abs(nd-pos.y)*0.015;
	
	cbuff += vec4(amnt*0.2, tan(amnt*0.2) , amnt*pos.x, 1.0);
	}
	
	vec4 dbuff =  texture2D(backbuffer,1.0-pos)*0.1;
  	gl_FragColor = cbuff -  dbuff;
}


