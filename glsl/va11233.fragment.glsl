#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / vec2(200,200.0);
	pos.x -= 2.0;
	float amnt = 3.0;
	float nd = 1.0;
	vec4 cbuff = vec4(0.0);
	for(float i = 0.9; i < 20.5; ++i){
		nd = sin(1.4*2.8*pos.y + (i*0.8+sin(0.0)*0.8) + time)*0.3+0.1 + pos.x;
		amnt = 2.0/abs(nd+pos.x)*.01; 
		cbuff += vec4(amnt, amnt*0.3*pos.y , amnt*0.8*pos.y*(pos.y*0.3), 501.0);
	}
  	gl_FragColor = cbuff ;
}