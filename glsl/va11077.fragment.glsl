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
	vec4 old = texture2D(backbuffer, pos);
	
	old += vec4(-0.06);
	
	float ntime = 0.0;

	for(float i = 0.0; i < 5.0; i++){
		nd = sin(3.14 * 0.2 * pos.x + (i * 0.3 + sin(time) * 0.001) + time) * 1.0 + 0.1 + pos.x;
//		nd = pos.x;
//		amnt = 1.0 / abs(nd - pos.y) * 0.001;
		amnt = 1.5 / abs(nd - pos.y) * 0.001;
//		cbuff += vec4(amnt, amnt * 0.3, amnt * pos.y, 1);
		cbuff += vec4(amnt * pos.x, amnt * 0.3, amnt * pos.y, 0);
	}

	cbuff += old;
//	vec4 dbuff = texture2D(backbuffer, 1.0 - pos) * 0.1;

 	gl_FragColor = cbuff;
// 	gl_FragColor = old;
	
}
