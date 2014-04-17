#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / vec2(200,150);
	pos.x -= 2.0;
	float amnt = 3.0;
	float nd = 1.0;
	vec4 cbuff = vec4(0.0);
	for(float i = 12.0; i < 20.0; ++i){
		nd = sin(3.4*1.8*pos.y + (i*0.8+sin(0.0)*0.8) + time)*0.8+0.1 + pos.x;
		amnt = 1.2/abs(nd+pos.x)*0.03; 
		cbuff += vec4(amnt, amnt*0.3*pos.y , amnt*0.6*pos.y*(pos.y*0.4), 0.0);
	}
  	gl_FragColor = cbuff ;
}