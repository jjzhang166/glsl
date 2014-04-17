#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	int zoom = 150;
	vec2 asd = vec2(zoom);
	vec2 pos = gl_FragCoord.xy / asd;
	float amnt = 200.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);
	for(float i = 0.0; i < 20.0; ++i){
		nd = sin(3.1452*2.8*pos.x + (i*0.8+sin(time)) + time) + pos.x;
		amnt = 1.0/abs(nd-pos.y)*0.01; 
		cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y*0.4, 081.0);
	}
  	gl_FragColor = cbuff ;
}