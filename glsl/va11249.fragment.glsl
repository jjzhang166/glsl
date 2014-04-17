#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 100.0;
	float nd = 1.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<5.0;i++){
	nd =sin(3.14*0.8*pos.x + (i*0.2+sin(+time)*.8) + time)*0.4+0.1 + pos.x;
	amnt = 1.0/abs(nd-pos.y)*0.05; 
	
	cbuff += vec4(amnt, amnt*0.1 , amnt*pos.y, 061.0);
	}
	
  gl_FragColor = cbuff ;
}

