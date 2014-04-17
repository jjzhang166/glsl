#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution * 10.0;
	float amnt = 100.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<15.0;i++){
	nd =sin(.14*1.8*pos.x + (i*1.02+sin(+time)*.8) + time)*4.4+0.1 + pos.x ;
	amnt = 0.5/abs(nd-pos.y)*.115; 
	
	cbuff += vec4(amnt, amnt*0.1 , amnt*pos.y, 010.0);
	}
	
  gl_FragColor = cbuff ;
}

