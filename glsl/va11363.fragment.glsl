#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 0.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);
	

	
		nd =pos.x;
		amnt = 1.0/abs(nd-pos.y)*0.05; 
		
		cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y, 1.0);
	
	
	gl_FragColor = cbuff;
}
